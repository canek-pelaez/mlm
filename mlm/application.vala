/*
 * This file is part of mlm.
 *
 * Copyright 2013 Canek Peláez Valdés
 *
 * mlm is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * mlm is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with mlm. If not, see <http://www.gnu.org/licenses/>.
 */

namespace MLM {

    public class Application : Gtk.Application {

        public bool dirty { get; set; }

        private FileTags tags;
        private ApplicationWindow window;
        private int total;
        private int index;
        private Gee.ArrayList<GLib.File> files;
        private Gee.BidirListIterator<GLib.File> iterator;

        public Application() {
            application_id = "mx.unam.MLM";
            flags |= GLib.ApplicationFlags.HANDLES_OPEN;

            var action = new GLib.SimpleAction("about", null);
            action.activate.connect(() => about());
            add_action(action);

            action = new GLib.SimpleAction("quit", null);
            action.activate.connect(() => quit());
            add_action(action);
        }

        public override void startup() {
            base.startup();
            var menu = new GLib.Menu();
            menu.append(_("About"), "app.about");
            menu.append(_("Quit"), "app.quit");
            set_app_menu(menu);
        }

        public override void activate() {
            base.activate();

            if (window == null)
                window = new ApplicationWindow(this);

            if (total == 0) {
                window.disable(UIItemFlags.NEXT|UIItemFlags.SAVE);
            } else {
                iterator = files.bidir_list_iterator();
                next();
                if (total == 1)
                    window.disable(UIItemFlags.NEXT);
            }

            window.last = total;
            window.disable(UIItemFlags.PREVIOUS);
            window.present();
        }

        public override void open(GLib.File[] files, string hint) {
            this.files = new Gee.ArrayList<GLib.File>();
            foreach (var file in files) {
                FileInfo info = null;
                try {
                    info = file.query_info("standard::*",
                                           GLib.FileQueryInfoFlags.NONE);
                } catch (GLib.Error e) {
                    var p = file.get_path();
                    var m = "There was a problem getting info from '%s'".printf(p);
                    GLib.warning(m);
                    continue;
                }
                var ctype = info.get_content_type();
                if (ctype != "audio/mpeg") {
                    var p = file.get_path();
                    var m = "The filename '%s' is not an MP3".printf(p);
                    GLib.warning(m);
                    continue;
                }
                this.files.add(file);
            }
            total = this.files.size;
            this.files.sort(compare_files);
            activate();
        }

        private static int compare_files(File a, File b) {
            if (a.get_path() < b.get_path())
                return -1;
            if (a.get_path() > b.get_path())
                return 1;
            return 0;
        }

        private void update_mp3() {
            var file = iterator.get();
            tags = new FileTags(file.get_path());
            window.filename = file.get_path();
            window.artist = tags.artist != null ? tags.artist : "";
            window.title_ = tags.title != null ? tags.title : "";
            window.album = tags.album != null ? tags.album : "";
            window.year = tags.year != -1 ? tags.year : 1900;
            window.disc = tags.disc_number != -1 ? tags.disc_number : 1;
            window.track = tags.track_number != -1 ? tags.track_number : 1;
            window.total = tags.track_count != -1 ? tags.track_count : 1;
            var genre = Genre.all()[tags.genre].to_string();
            window.genre = genre != null ? genre : "";
            window.comment = tags.comment != null ? tags.comment : "";
            window.composer = tags.composer != null ? tags.composer : "";
            window.original = tags.original_artist != null ? tags.original_artist : "";
            window.cover_data = tags.front_cover_picture;
            window.artist_data = tags.artist_picture;
            window.disable(UIItemFlags.SAVE);
            window.current = index;
        }

        public void previous() {
            if (!iterator.has_previous())
                return;
            iterator.previous();
            index--;
            window.enable(UIItemFlags.NEXT);
            if (!iterator.has_previous())
                window.disable(UIItemFlags.PREVIOUS);
            update_mp3();
        }

        public void next() {
            if (!iterator.has_next())
                return;
            iterator.next();
            index++;
            window.enable(UIItemFlags.PREVIOUS);
            if (!iterator.has_next())
                window.disable(UIItemFlags.NEXT);
            update_mp3();
        }

        public void save() {
            set_tags_from_window(tags);
            tags.update();
        }

        public void set_tags_in_file(string dest) {
            var etags = new FileTags(dest);
            set_tags_from_window(etags);
            etags.update();
        }

        private void set_tags_from_window(FileTags t) {
            t.update_artist(window.artist);
            t.update_title(window.title_);
            t.update_album(window.album);
            t.update_year(window.year);
            t.update_disc_number(window.disc);
            t.update_track(window.track, window.total);
            t.update_genre(window.genre_id);
            t.update_comment(window.comment);
            t.update_composer(window.composer);
            t.update_original_artist(window.original);
            t.update_front_cover_picture(window.cover_data);
            t.update_artist_picture(window.artist_data);
        }

        private void about() {
            string[] authors = { "Canek Peláez Valdés <canek@ciencias.unam.mx>" };
            Gtk.show_about_dialog(
                window,
                "authors", authors,
                "comments", _("A Gtk+ based music library maintainer"),
                "copyright", "Copyright 2014 Canek Peláez Valdés",
                "license-type", Gtk.License.GPL_3_0,
                "logo-icon-name", "mlm",
                "version", Config.PACKAGE_VERSION,
                "website", "http://github.com/canek-pelaez/mlm",
                "wrap-license", true);
        }
    }
}
