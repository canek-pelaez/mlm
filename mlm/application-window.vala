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

    public enum UIItemFlags {
        PREVIOUS     = 1 << 0,
        NEXT         = 1 << 1,
        SAVE         = 1 << 2,
        MASK         = 0x07;
    }

    [GtkTemplate (ui = "/mx/unam/MLM/mlm.ui")]
    public class ApplicationWindow : Gtk.ApplicationWindow {

        [GtkChild]
        private Gtk.Button previous;
        [GtkChild]
        private Gtk.Button next;
        [GtkChild]
        private Gtk.Button save;

        [GtkChild (name = "artist")]
        private Gtk.Entry artist_widget;
        public string artist {
            get { return artist_widget.get_text(); }
            set { artist_widget.set_text(value); }
        }

        [GtkChild (name = "title")]
        private Gtk.Entry title_widget;
        public string title_ {  // title is used by Gtk.ApplicationWindow
            get { return title_widget.get_text(); }
            set { title_widget.set_text(value); }
        }

        [GtkChild (name = "album")]
        private Gtk.Entry album_widget;
        public string album {
            get { return album_widget.get_text(); }
            set { album_widget.set_text(value); }
        }

        [GtkChild (name = "year")]
        private Gtk.SpinButton year_widget;
        public int year {
            get { return (int)year_widget.get_value(); }
            set { year_widget.set_value(value); }
        }

        [GtkChild (name = "disc")]
        private Gtk.SpinButton disc_widget;
        public int disc {
            get { return (int)disc_widget.get_value(); }
            set { disc_widget.set_value(value); }
        }

        [GtkChild (name = "track")]
        private Gtk.SpinButton track_widget;
        public int track {
            get { return (int)track_widget.get_value(); }
            set { track_widget.set_value(value); }
        }

        [GtkChild (name = "total")]
        private Gtk.SpinButton total_widget;
        public int total {
            get { return (int)total_widget.get_value(); }
            set { total_widget.set_value(value); }
        }

        [GtkChild (name = "genre")]
        private Gtk.Entry genre_widget;
        public string genre {
            get { return genre_widget.get_text(); }
            set { genre_widget.set_text(value); }
        }

        [GtkChild (name = "comment")]
        private Gtk.Entry comment_widget;
        public string comment {
            get { return comment_widget.get_text(); }
            set { comment_widget.set_text(value); }
        }

        [GtkChild (name = "composer")]
        private Gtk.Entry composer_widget;
        public string composer {
            get { return composer_widget.get_text(); }
            set { composer_widget.set_text(value); }
        }

        [GtkChild (name = "original")]
        private Gtk.Entry original_widget;
        public string original {
            get { return original_widget.get_text(); }
            set { original_widget.set_text(value); }
        }

        [GtkChild]
        private Gtk.Image cover_image;
        [GtkChild]
        private Gtk.Image artist_image;
        [GtkChild]
        private Gtk.ListStore genre_model;
        [GtkChild]
        private Gtk.Adjustment year_adjustment;

        public Gdk.Pixbuf _cover_pixbuf;
        public Gdk.Pixbuf cover_pixbuf {
            get { return _cover_pixbuf; }
            set { _cover_pixbuf = update_image(cover_image, value); }
        }

        public Gdk.Pixbuf _artist_pixbuf;
        public Gdk.Pixbuf artist_pixbuf {
            get { return _artist_pixbuf; }
            set { _artist_pixbuf = update_image(artist_image, value); }
        }

        private Application app;

        public ApplicationWindow(Gtk.Application application) {
            GLib.Object(application: application);
            app = application as Application;

            Gtk.Window.set_default_icon_name("mlm");
            var provider = new Gtk.CssProvider();
            try {
                var file = GLib.File.new_for_uri("resource:///mx/unam/MLM/mlm.css");
                provider.load_from_file(file);
            } catch (GLib.Error e) {
                GLib.warning("There was a problem loading 'mlm.css'");
            }
            Gtk.StyleContext.add_provider_for_screen(Gdk.Screen.get_default(),
                                                      provider, 999);
            var date_time = new GLib.DateTime.now_local();
            year_adjustment.upper = date_time.get_year();

            /* Stupid GtkBuilder */
            genre_widget.completion = new Gtk.EntryCompletion();
            genre_widget.completion.model = genre_model;
            genre_widget.completion.text_column = 0;

            _cover_pixbuf = cover_image.get_pixbuf();
            _artist_pixbuf = artist_image.get_pixbuf();
        }

        [GtkCallback]
        public void on_next_clicked() {
            app.next();
        }

        [GtkCallback]
        public void on_previous_clicked() {
            app.previous();
        }

        [GtkCallback]
        public void on_clear_artist_clicked() {}

        [GtkCallback]
        public void on_clear_cover_clicked() {}

        private Gdk.Pixbuf? select_image(string title) {
            Gdk.Pixbuf pixbuf = null;
            var dialog =
                new Gtk.FileChooserDialog(title, this,
                                          Gtk.FileChooserAction.OPEN,
                                          _("_Cancel"), Gtk.ResponseType.CANCEL,
                                          _("_Open"), Gtk.ResponseType.ACCEPT);
            int r = dialog.run();
            string fn = dialog.get_filename();
            dialog.destroy();
            if (r != Gtk.ResponseType.ACCEPT)
                return pixbuf;
            try {
                uint8[] bytes;
                FileUtils.get_data(fn, out bytes);
                var mis = new MemoryInputStream.from_data(bytes, null);
                pixbuf = new Gdk.Pixbuf.from_stream(mis);
            } catch (GLib.FileError fe) {
                stderr.printf("There was an error reading from '%s'.\n", fn);
            } catch (GLib.Error e) {
                stderr.printf("There was an error with the image '%s'.\n", fn);
            }
            return pixbuf;
        }

        [GtkCallback]
        public void on_open_artist_clicked() {
            var pixbuf = select_image("Select image for artist");
            if (pixbuf != null)
                artist_pixbuf = pixbuf;
        }

        [GtkCallback]
        public void on_open_cover_clicked() {
            var pixbuf = select_image("Select image for cover");
            if (pixbuf != null)
                cover_pixbuf = pixbuf;
        }

        [GtkCallback]
        public void on_reencode_clicked() {}

        [GtkCallback]
        public void on_save_clicked() {
            app.save();
            save.sensitive = false;
        }

        [GtkCallback]
        public void on_window_destroy() {
            application.quit();
        }

        [GtkCallback]
        public void tags_changed() {
            save.sensitive = true;
            app.dirty = true;
        }

        private Gdk.Pixbuf update_image(Gtk.Image image, Gdk.Pixbuf pixbuf) {
            var scale = 150.0 / double.max(pixbuf.width, pixbuf.height);
            var thumb = pixbuf.scale_simple((int)(pixbuf.width*scale),
                                            (int)(pixbuf.height*scale),
                                            Gdk.InterpType.BILINEAR);
            image.set_from_pixbuf(thumb);
            tags_changed();
            return pixbuf;
        }

        private void items_set_sensitive(UIItemFlags flags, bool s) {
            if ((flags & UIItemFlags.PREVIOUS) != 0)
                previous.sensitive = s;
            if ((flags & UIItemFlags.NEXT) != 0)
                next.sensitive = s;
            if ((flags & UIItemFlags.SAVE) != 0)
                save.sensitive = s;
        }

        public void enable(UIItemFlags flags) {
            items_set_sensitive(flags, true);
        }

        public void disable(UIItemFlags flags) {
            items_set_sensitive(flags, false);
        }
    }
}
