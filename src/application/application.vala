/*
 * This file is part of mlm.
 *
 * Copyright © 2013-2019 Canek Peláez Valdés
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
        /* The shortcuts window. */
        private ShortcutsWindow shortcuts_window;
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
        /* Whether the tags have been modified. */
        private bool modified;

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

            var action = new GLib.SimpleAction("prev", null);
            action.activate.connect(previous);
            add_action(action);
            set_accels_for_action("app.prev", new string[]{"<Ctrl>Page_Up"});

            action = new GLib.SimpleAction("next", null);
            action.activate.connect(next);
            add_action(action);
            set_accels_for_action("app.next", new string[]{"<Ctrl>Page_Down"});

            action = new GLib.SimpleAction("save", null);
            action.activate.connect(save);
            add_action(action);
            set_accels_for_action("app.save", new string[]{"<Ctrl>S"});

            action = new GLib.SimpleAction("play", null);
            action.activate.connect(play);
            add_action(action);
            set_accels_for_action("app.play", new string[]{"<Ctrl>space"});

            action = new GLib.SimpleAction("start-encoder", null);
            action.activate.connect(start_encoder);
            add_action(action);

            action = new GLib.SimpleAction("stop-encoder", null);
            action.activate.connect(stop_encoder);
            add_action(action);

            action = new GLib.SimpleAction("shortcuts", null);
            action.activate.connect(shortcuts);
            add_action(action);
            set_accels_for_action("app.shortcuts", new string[]{"<Ctrl>T"});

            action = new GLib.SimpleAction("about", null);
            action.activate.connect(about);
            add_action(action);
            set_accels_for_action("app.about", new string[]{"<Ctrl>B"});

            action = new GLib.SimpleAction("quit", null);
            action.activate.connect(quit);
            add_action(action);
            set_accels_for_action("app.quit", new string[]{"<Ctrl>Q",
                                                           "Escape"});
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
            this.files.sort((a,b) => a.get_path().collate(b.get_path()));
            activate();
        }

        /**
         * Seeks a percentage in the player.
         * @return ''true'' if the seeking succeeds; ''false'' otherwise.
         */
        public bool seek_player(double percentage) {
            return player.seek(percentage);
        }

        /* Returns the player completion percentage. */
        private double player_completion() {
            if (player == null || !player.working)
                return 0.0;
            int64 d, p;
            return player.get_completion(out d, out p);
        }

        /* Returns a string representing the playing time. */
        private string player_time() {
            if (player == null || !player.working)
                return "00:00";
            int64 position = -1, duration = -1;
            player.get_completion(out position, out duration);
            int64 tsecs = duration / 1000000000l;
            int mins = (int)(tsecs / 60);
            int secs = (int)(tsecs % 60);
            return "%02d:%02d".printf(mins, secs);
        }

        /* The previous action. */
        private void previous() {
            if (player != null && player.working)
                player.pause();
            if (!iterator.has_previous())
                return;
            iterator.previous();
            current--;
            update_file();
        }

        /* The next action. */
        private void next() {
            if (player != null && player.working)
                player.pause();
            if (!iterator.has_next())
                return;
            iterator.next();
            current++;
            update_file();
        }

        /* The save action. */
        public void save() {
            if (!modified)
                return;
            tags.update();
        }

        /* The play action. */
        private void play() {
            if (player != null && !player.working) {
                window.set_play_icon(ApplicationWindow.ICON_NAME_PAUSE);
                player.play();
            } else {
                window.set_play_icon(ApplicationWindow.ICON_NAME_PLAY);
                player.pause();
            }
        }

        /* Starts the encoder. */
        private void start_encoder() {
            window.update_encoding(0.0);
            var target = "";
            string prefix = (
                (tags.artist != null ? tags.artist.replace("/", "_") : "") +
                " - " +
                (tags.title != null ? tags.title.replace("/", "_") : ""));
            int cont = 0;
            do {
                string name = prefix + ((cont == 0) ? ".mp3" :
                                        "-%d.mp3".printf(cont));
                target = string.join(Path.get_dirname(filename), name);
                cont++;
            } while (GLib.FileUtils.test(target, GLib.FileTest.EXISTS));
            encoder = new Encoder(filename, target);
            encoder.encode();
            GLib.Idle.add(update_encoding);
        }

        /* Stops the encoder. */
        private void stop_encoder() {
            if (target == null || encoder == null)
                return;
            encoder.cancel();
            GLib.FileUtils.remove(target);
            target = null;
            encoder = null;
        }

        /* The about action. */
        private void about() {
            string[] authors = { "Canek Peláez Valdés " +
                                 "<canek@ciencias.unam.mx>" };
            Gtk.show_about_dialog(
                window,
                "authors",        authors,
                "comments",       _("A Gtk+ based music library maintainer"),
                "copyright",      "Copyright © 2013-2019 Canek Peláez Valdés",
                "license-type",   Gtk.License.GPL_3_0,
                "logo-icon-name", "mlm",
                "version",        Config.PACKAGE_VERSION,
                "website",        ("https://canek@aztlan.fciencias.unam.mx/" +
                                   "gitlab/canek/mlm.git"),
                "wrap-license",   true);
        }

        /* The shortcuts action. */
        private void shortcuts() {
            if (shortcuts == null)
                shortcuts_window = new ShortcutsWindow();
            shortcuts_window.show_all();
        }

        /* Updates a file. */
        private void update_file() {
            if (player != null)
                player.finish();
            var file = iterator.get();
            filename = file.get_path();
            tags = new FileTags(filename);
            tags.modified.connect(() => modified = true);
            window.update_view(filename, tags, current, total);
            GLib.Idle.add(dispose_player);
        }

        /* Updates the encoding process. */
        private bool update_encoding() {
            if (encoder == null || target == null)
                return false;
            double p = encoder.get_completion();
            window.update_encoding(p);
            if (encoder.working)
                return true;
            var ntags = new FileTags(filename);
            ntags.copy(tags);
            ntags.update();
            encoder = null;
            target = null;
            window.update_encoding(-1.0);
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
                window.set_play_icon(ApplicationWindow.ICON_NAME_PAUSE);
                GLib.Idle.add(monitor_player);
                break;
            case Gst.State.PAUSED:
                if (player_completion() == 0.0)
                    window.update_player_view(0.0, "00:00");
                window.set_play_icon(ApplicationWindow.ICON_NAME_PLAY);
                break;
            }
        }

        /* Monitors the player in the model. */
        private bool monitor_player() {
            if (player != null && !player.working) {
                window.set_play_icon(ApplicationWindow.ICON_NAME_PLAY);
                return false;
            }
            window.update_player_view(player_completion(),
                                      player_time());
            return true;
        }

    }
}
