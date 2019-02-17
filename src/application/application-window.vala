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

    public enum UIItemFlags {
        PREVIOUS     = 1 << 0,
        NEXT         = 1 << 1,
        REENCODE     = 1 << 2,
        SAVE         = 1 << 3,
        REST         = 1 << 4,
        ALL          = 0x1f;
    }

    [GtkTemplate (ui = "/mx/unam/MLM/mlm.ui")]
    public class ApplicationWindow : Gtk.ApplicationWindow {

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
        private Gtk.Button previous;

        [GtkChild]
        private Gtk.Button next;

        [GtkChild]
        private Gtk.MenuButton reencode;

        [GtkChild]
        private Gtk.Popover popover;

        [GtkChild]
        private Gtk.ProgressBar bar;

        [GtkChild]
        private Gtk.Frame frame;

        [GtkChild]
        private Gtk.Button save;

        [GtkChild (name = "filename")]
        private Gtk.Label filename_widget;
        private string _filename;
        public string filename {
            get { return _filename; }
            set { define_filename(value); }
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

        [GtkChild (name = "band")]
        private Gtk.Entry band_widget;
        public string band {
            get { return band_widget.get_text(); }
            set { band_widget.set_text(value); }
        }

        [GtkChild (name = "year")]
        private Gtk.SpinButton year_widget;
        public int year {
            get { return (int)year_widget.get_value(); }
            set { year_widget.set_value(value); }
        }

        [GtkChild]
        private Gtk.Adjustment year_adjustment;

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

        [GtkChild]
        private Gtk.ComboBox genre_combobox;
        public int genre_id {
            get { return genre_combobox.active; }
        }

        [GtkChild (name = "genre")]
        private Gtk.Entry genre_widget;
        public string genre {
            get { return genre_widget.get_text(); }
            set { define_genre(value); }
        }

        [GtkChild]
        private Gtk.ListStore genre_model;

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

        public uint8[] _cover_data;
        public uint8[] cover_data {
            get { return _cover_data; }
            set { _cover_data = update_image(cover_image, value, _cover_data); }
        }

        [GtkChild]
        private Gtk.Image artist_image;

        public uint8[] _artist_data;
        public uint8[] artist_data {
            get { return _artist_data; }
            set { _artist_data = update_image(artist_image, value, _artist_data); }
        }

        [GtkChild]
        private Gtk.Image play_image;

        [GtkChild]
        private Gtk.Adjustment play_adjustment;

        [GtkChild]
        private Gtk.Label time;

        private bool ignore_popover;

        private Application app;
        private Player player;
        private Encoder encoder;
        private string target;

        private const string ICON_NAME_CD = "media-optical-cd-audio-symbolic";
        private const string ICON_NAME_AVATAR = "avatar-default-symbolic";
        private const string ICON_NAME_PLAY = "media-playback-start-symbolic";
        private const string ICON_NAME_PAUSE = "media-playback-pause-symbolic";
        private const Gtk.IconSize ICON_SIZE = Gtk.IconSize.SMALL_TOOLBAR;

        public ApplicationWindow(Gtk.Application application) {
            GLib.Object(application: application);
            app = application as Application;

            Gtk.Window.set_default_icon_name("mlm");
            var provider = new Gtk.CssProvider();
            try {
                var file = GLib.File.new_for_uri("resource:///mx/unam/MLM/mlm.css");
                provider.load_from_file(file);
            } catch (GLib.Error e) {
                stderr.printf("There was a problem loading ‘mlm.css’\n");
            }
            Gtk.StyleContext.add_provider_for_screen(Gdk.Screen.get_default(),
                                                      provider, 999);
            var date_time = new GLib.DateTime.now_local();
            year_adjustment.upper = date_time.get_year();

            _cover_data = null;
            _artist_data = null;

            reencode.bind_property("active", popover, "visible",
                                   GLib.BindingFlags.BIDIRECTIONAL);
            ignore_popover = false;

            genre_model.set_sort_column_id(0, Gtk.SortType.ASCENDING);
        }

        [GtkCallback]
        public bool on_match_selected(Gtk.TreeModel m, Gtk.TreeIter i) {
            genre_combobox.set_active_iter(i);
            return true;
        }

        [GtkCallback]
        public void on_previous_clicked() {
            if (player.working)
                player.pause();
            app.previous();
        }

        [GtkCallback]
        public void on_next_clicked() {
            if (player.working)
                player.pause();
            app.next();
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
                warning(_("There was an error loading image '%s'").printf(fn));
            }
            return null;
        }

        [GtkCallback]
        public void on_open_artist_clicked() {
            var data = select_image(_("Select image for artist"));
            if (data != null)
                artist_data = data;
        }

        [GtkCallback]
        public void on_open_cover_clicked() {
            var data = select_image(_("Select image for cover"));
            if (data != null)
                cover_data = data;
        }

        [GtkCallback]
        public void popover_visibility_changed() {
            if (ignore_popover)
                return;
            if (!popover.visible) {
                if (target != null && encoder != null) {
                    encoder.cancel();
                    GLib.FileUtils.remove(target);
                    target = null;
                    encoder = null;
                }
                return;
            }
            int cont = 0;
            do {
                string d = Path.get_dirname(filename);
                string s = GLib.Path.DIR_SEPARATOR_S;
                string a = artist.replace("/", "_");
                string t = title_.replace("/", "_");
                string e = (cont == 0) ? ".mp3" : "-%d.mp3".printf(cont);
                target = d + s + a + " - " + t + e;
                cont++;
            } while (GLib.FileUtils.test(target, GLib.FileTest.EXISTS));
            encoder = new Encoder(filename, target);
            encoder.encode();
            bar.set_fraction(0.0);
            GLib.Idle.add(upgrade_progressbar);
        }

        [GtkCallback]
        public void on_save_clicked() {
            app.save();
            save.sensitive = false;
        }

        private bool upgrade_progressbar() {
            if (encoder == null || target == null)
                return false;
            double p = encoder.get_completion();
            bar.set_fraction(p);
            if (encoder.working)
                return true;
            app.set_tags_in_file(target);
            encoder = null;
            target = null;
            ignore_popover = true;
            popover.visible = false;
            ignore_popover = false;
            return false;
        }

        private void player_state_changed(Gst.State state) {
            switch (state) {
            case Gst.State.PLAYING:
                play_image.set_from_icon_name(ICON_NAME_PAUSE, ICON_SIZE);
                GLib.Idle.add(monitor_play);
                break;
            case Gst.State.PAUSED:
                int64 d, p;
                if (player.get_completion(out d, out p) == 0.0)
                    reset_timer();
                play_image.set_from_icon_name(ICON_NAME_PLAY, ICON_SIZE);
                break;
            }
        }

        private void reset_timer() {
            play_image.set_from_icon_name(ICON_NAME_PLAY, ICON_SIZE);
            play_adjustment.set_value(0.0);
            time.set_text("00:00");
        }

        private bool monitor_play() {
            if (!player.working) {
                play_image.set_from_icon_name(ICON_NAME_PLAY, ICON_SIZE);
                return false;
            }

            int64 position = -1, duration = -1;
            double p = player.get_completion(out position, out duration);
            play_adjustment.set_value(p);
            int64 tsecs = duration / 1000000000l;
            int mins = (int)(tsecs / 60);
            int secs = (int)(tsecs % 60);
            time.set_text("%02d:%02d".printf(mins, secs));
            return true;
        }

        [GtkCallback]
        public void on_play_clicked() {
            if (!player.working) {
                play_image.set_from_icon_name(ICON_NAME_PAUSE, ICON_SIZE);
                player.play();
            } else {
                play_image.set_from_icon_name(ICON_NAME_PLAY, ICON_SIZE);
                player.pause();
            }
        }

        [GtkCallback]
        public void on_window_destroy() {
            application.quit();
        }

        [GtkCallback]
        public void tags_changed() {
            if (track > total)
                total = track;
            save.sensitive = true;
        }

        [GtkCallback]
        public bool on_window_key_press(Gdk.EventKey e) {
            if (e.keyval == Gdk.Key.Page_Up) {
                on_previous_clicked();
                return true;
            }
            if (e.keyval == Gdk.Key.Page_Down) {
                on_next_clicked();
                return true;
            }
            if (e.keyval == Gdk.Key.Escape) {
                app.quit();
                return true;
            }
            if (e.keyval == Gdk.Key.space &&
                (e.state & Gdk.ModifierType.CONTROL_MASK) != 0) {
                on_play_clicked();
            }
            return false;
        }

        [GtkCallback]
        public bool on_scale_change_value(Gtk.ScrollType scroll, double value) {
            if (value < 0.0)
                value = 0.0;
            if (value > 1.0)
                value = 1.0;
            if (!player.seek(value)) {
                reset_timer();
                return true;
            }
            return false;
        }

        private void set_default_image(Gtk.Image image) {
            if (image == cover_image)
                image.set_from_icon_name(ICON_NAME_CD, ICON_SIZE);
            else
                image.set_from_icon_name(ICON_NAME_AVATAR, ICON_SIZE);
            image.pixel_size = 140;
        }

        private uint8[] update_image(Gtk.Image image,
                                     uint8[]   data,
                                     uint8[]   original) {
            if (data == null) {
                if (original == null)
                    set_default_image(image);
                return original;
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
                warning(_("Could not set pixbuf from data."));
                if (original == null)
                    set_default_image(image);
                return original;
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
            if ((flags & UIItemFlags.REENCODE) != 0)
                reencode.sensitive = s;
            if ((flags & UIItemFlags.SAVE) != 0)
                save.sensitive = s;
            if ((flags & UIItemFlags.REST) != 0)
                frame.sensitive = s;
        }

        private void define_genre(string g) {
            Gtk.TreeIter iter = {};
            if (!genre_model.get_iter_first(out iter))
                return;
            int c = 0;
            do {
                string ig;
                genre_model.get(iter, 0, out ig);
                if (g == ig)
                    genre_combobox.active = c;
                c++;
            } while (genre_model.iter_next(ref iter));
        }

        private void define_filename(string f) {
            _filename = f;
            var basename = GLib.Path.get_basename(_filename);
            var markup = GLib.Markup.printf_escaped("<b>%s</b>", basename);
            filename_widget.set_markup(markup);
            if (player != null)
                player.finish();
            reset_timer();
            GLib.Idle.add(dispose_player);
        }

        private bool dispose_player() {
            if (player == null || player.state == Gst.State.NULL) {
                player = new Player(filename);
                player.state_changed.connect(player_state_changed);
                return false;
            }
            return true;
        }

        public void enable(UIItemFlags flags) {
            items_set_sensitive(flags, true);
        }

        public void disable(UIItemFlags flags) {
            items_set_sensitive(flags, false);
        }

        public void warning(string message) {
            var dialog = new Gtk.MessageDialog(
                this, Gtk.DialogFlags.DESTROY_WITH_PARENT,
                Gtk.MessageType.WARNING, Gtk.ButtonsType.CLOSE,
                message);
            dialog.title = _("Warning");
            dialog.run();
            dialog.destroy();
        }
    }
}
