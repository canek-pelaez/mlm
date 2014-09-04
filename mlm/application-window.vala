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
        private Gtk.HeaderBar header;

        private int _current;
        public int current {
            get { return _current; }
            set {
                _current = value;
                header.set_subtitle("%d / %d".printf(_current, _last));
            }
        }

        private int _last;
        public int last {
            get { return _last; }
            set {
                _last = value;
                header.set_subtitle("%d / %d".printf(_current, _last));
            }
        }

        [GtkChild]
        private Gtk.Button save;

        [GtkChild (name = "filename")]
        private Gtk.Label filename_widget;
        public string filename {
            get { return filename_widget.get_text(); }
            set {
                var markup = GLib.Markup.printf_escaped("<b>%s</b>", value);
                filename_widget.set_markup(markup);
            }
        }

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

        public uint8[] _cover_data;
        public uint8[] cover_data {
            get { return _cover_data; }
            set { _cover_data = update_image(cover_image, value); }
        }

        public uint8[] _artist_data;
        public uint8[] artist_data {
            get { return _artist_data; }
            set { _artist_data = update_image(artist_image, value); }
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

            _cover_data = null;
            _artist_data = null;
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

        private uint8[]? select_image(string title) {
            var dialog =
                new Gtk.FileChooserDialog(title, this,
                                          Gtk.FileChooserAction.OPEN,
                                          _("_Cancel"), Gtk.ResponseType.CANCEL,
                                          _("_Open"), Gtk.ResponseType.ACCEPT);
            int r = dialog.run();
            string fn = dialog.get_filename();
            dialog.destroy();
            if (r != Gtk.ResponseType.ACCEPT)
                return null;
            try {
                uint8[] data;
                FileUtils.get_data(fn, out data);
                return data;
            } catch (GLib.FileError fe) {
                GLib.warning("There was an error reading from '%s'.\n", fn);
            }
            return null;
        }

        [GtkCallback]
        public void on_open_artist_clicked() {
            var data = select_image("Select image for artist");
            if (data != null)
                artist_data = data;
        }

        [GtkCallback]
        public void on_open_cover_clicked() {
            var data = select_image("Select image for cover");
            if (data != null)
                cover_data = data;
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

        [GtkCallback]
        public bool on_window_key_press(Gdk.EventKey e) {
            if (e.keyval == Gdk.Key.Page_Up) {
                app.previous();
                return true;
            }
            if (e.keyval == Gdk.Key.Page_Down) {
                app.next();
                return true;
            }
            if (e.keyval == Gdk.Key.Escape) {
                app.quit();
                return true;
            }
            return false;
        }

        private uint8[] update_image(Gtk.Image image, uint8[] data) {
            if (data == null) {
                if (image == cover_image)
                    image.set_from_icon_name("media-optical-cd-audio-symbolic",
                                             Gtk.IconSize.LARGE_TOOLBAR);
                else
                    image.set_from_icon_name("avatar-default-symbolic",
                                             Gtk.IconSize.LARGE_TOOLBAR);
                image.pixel_size = 140;
                return data;
            }
            var mis = new MemoryInputStream.from_data(data, null);
            Gdk.Pixbuf thumb = null;
            try {
                var pixbuf = new Gdk.Pixbuf.from_stream(mis);
                var scale = 150.0 / double.max(pixbuf.width, pixbuf.height);
                thumb = pixbuf.scale_simple((int)(pixbuf.width*scale),
                                            (int)(pixbuf.height*scale),
                                            Gdk.InterpType.BILINEAR);
            } catch (GLib.Error e) {
                GLib.warning("Could not set pixbuf from data.\n");
            }
            image.set_from_pixbuf(thumb);
            tags_changed();
            return data;
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
