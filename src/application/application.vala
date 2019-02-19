/*
 * This file is part of mlm.
 *
 * Copyright © 2013-2018 Canek Peláez Valdés
 *
 * This program is free software: you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option) any later
 * version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 * Author:
 *    Canek Peláez Valdés <canek@ciencias.unam.mx>
 */

namespace MLM {

    /**
     * MLM GUI application class.
     */
    public class Application : Gtk.Application {

        /* The application window. */
        private ApplicationWindow window;
        /* The list of files. */
        private Gee.ArrayList<GLib.File> files;
        /* The list iterator. */
        private Gee.BidirListIterator<GLib.File> iterator;
        /* The current filename. */
        private string filename;
        /* The file tags. */
        private FileTags tags;
        /* Total files. */
        private int total;
        /* Current index. */
        private int current;
        /* The player. */
        private Player player;
        /* The encoder. */
        private Encoder encoder;
        /* The target filename for the encoder. */
        private string target;

        /**
         * Initializes the application.
         */
        public Application() {
            application_id = "mx.unam.MLM";
            flags |= GLib.ApplicationFlags.HANDLES_OPEN;
        }

        /**
         * Starts up the application.
         */
        public override void startup() {
            base.startup();

            var action = new GLib.SimpleAction("about", null);
            action.activate.connect(about);
            add_action(action);
            add_accelerator("<Ctrl>A", "app.quit", null);

            action = new GLib.SimpleAction("quit", null);
            action.activate.connect(quit);
            add_action(action);
            add_accelerator("<Ctrl>Q", "app.quit", null);

            var menu = new GLib.Menu();
            menu.append(_("About"), "app.about");
            menu.append(_("Quit"), "app.quit");
            set_app_menu(menu);
        }

        /**
         * Activates the application.
         */
        public override void activate() {
            if (window == null)
                window = new ApplicationWindow(this);

            if (total > 0) {
                window.enable_ui(true);
                iterator = this.files.bidir_list_iterator();
                next();
            } else {
                window.enable_ui(false);
            }
            window.present();
        }

        /**
         * Opens an array of files.
         * @param files an array of GFiles to open.
         * @param hint a hint (or ""), but never NULL
         */
        public override void open(GLib.File[] files, string hint) {
            this.files = new Gee.ArrayList<GLib.File>();
            foreach (var file in files) {
                FileInfo info = null;
                try {
                    info = file.query_info("standard::*",
                                           GLib.FileQueryInfoFlags.NONE);
                } catch (GLib.Error e) {
                    var p = file.get_path();
                    var m = "There was a problem getting info from ‘%s’.".printf(p);
                    stderr.printf("%s\n", m);
                    continue;
                }
                var ctype = info.get_content_type();
                if (ctype != "audio/mpeg") {
                    stderr.printf("The filename ‘%s’ is not an MP3",
                                  file.get_path());
                    continue;
                }
                this.files.add(file);
            }
            total = this.files.size;
            this.files.sort(compare_files_by_path);
            activate();
        }

        /**
         * Iterates to the previous file.
         */
        public void previous() {
            if (player != null && player.working)
                player.pause();
            if (!iterator.has_previous())
                return;
            iterator.previous();
            current--;
            update_file();
        }

        /**
         * Iterates to the next file.
         */
        public void next() {
            if (player != null && player.working)
                player.pause();
            if (!iterator.has_next())
                return;
            iterator.next();
            current++;
            update_file();
        }

        /**
         * Saves the current file.
         */
        public void save() {
            window.update_model(tags);
            tags.update();
        }

        /**
         * Starts the encoder.
         */
        public void start_encoder() {
            target = window.get_normalized_filename(filename);
            encoder = new Encoder(filename, target);
            encoder.encode();
            GLib.Idle.add(update_encoding);
        }

        /**
         * Stops the encoder.
         */
        public void stop_encoder() {
            if (target == null || encoder == null)
                return;
            encoder.cancel();
            GLib.FileUtils.remove(target);
            target = null;
            encoder = null;
        }

        /**
         * Sets the cover picture data.
         * @param cover_data the cover picture data.
         */
        public void set_cover_picture_data(uint8[]? cover_data) {
            tags.cover_picture = cover_data;
        }

        /**
         * Sets the artist picture data.
         * @param artist_data the artist picture data.
         */
        public void set_artist_picture_data(uint8[]? artist_data) {
            tags.artist_picture = artist_data;
        }

        /**
         * Starts the player.
         */
        public void start_player() {
            if (is_player_playing())
                return;
            player.play();
        }

        /**
         * Pauses the player.
         */
        public void pause_player() {
            if (!is_player_playing())
                return;
            player.pause();
        }

        /**
         * Seeks a percentage in the player.
         * @return ''true'' if the seeking succeeds; ''false'' otherwise.
         */
        public bool seek_player(double percentage) {
            return player.seek(percentage);
        }

        /**
         * Returns the player completion percentage.
         * @return the player completion percentage.
         */
        public double player_completion() {
            if (!is_player_playing())
                return 0.0;
            int64 d, p;
            return player.get_completion(out d, out p);
        }

        /**
         * Whether the player is playing.
         * @return ''true'' if the player is playing, ''false'' otherwise.
         */
        public bool is_player_playing() {
            return (player != null && player.working);
        }

        /**
         * Returns a string representing the playing time.
         * @return a string representing the playing time.
         */
        public string player_time() {
            if (!is_player_playing())
                return "00:00";
            int64 position = -1, duration = -1;
            player.get_completion(out position, out duration);
            int64 tsecs = duration / 1000000000l;
            int mins = (int)(tsecs / 60);
            int secs = (int)(tsecs % 60);
            return "%02d:%02d".printf(mins, secs);
        }

        /* Compares two files by path. */
        private int compare_files_by_path(GLib.File a, GLib.File b) {
            return a.get_path().collate(b.get_path());
        }

        /* Updates a file. */
        private void update_file() {
            if (player != null)
                player.finish();
            var file = iterator.get();
            filename = file.get_path();
            tags = new FileTags(filename);
            window.update_view(filename, tags, current, total);
            GLib.Idle.add(dispose_player);
        }

        /* Save the tags in the view to a file. */
        private void save_tags(string filename) {
            var tags = new FileTags(filename);
            window.update_model(tags);
            tags.update();
        }

        /* The about action. */
        private void about() {
            window.about();
        }

        /* Updates the encoding process. */
        private bool update_encoding() {
            if (encoder == null || target == null)
                return false;
            double p = encoder.get_completion();
            window.update_encoding(p);
            if (encoder.working)
                return true;
            save_tags(target);
            encoder = null;
            target = null;
            window.hide_encoding();
            return false;
        }

        /* Disposes the current player. */
        private bool dispose_player() {
            if (player == null || player.state == Gst.State.NULL) {
                player = new Player(filename);
                player.state_changed.connect(player_state_changed);
                return false;
            }
            return true;
        }

        /* Player state changed handler. */
        private void player_state_changed(Gst.State state) {
            switch (state) {
            case Gst.State.PLAYING:
                window.play_started();
                break;
            case Gst.State.PAUSED:
                window.play_paused();
                break;
            }
        }
    }
}
