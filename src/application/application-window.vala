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

    [GtkTemplate (ui = "/mx/unam/MLM/mlm.ui")]
    public class ApplicationWindow : Gtk.ApplicationWindow {

        [GtkChild]
        private Gtk.HeaderBar header_bar;

        [GtkChild]
        private Gtk.Button previous_button;

        [GtkChild]
        private Gtk.Button next_button;

        [GtkChild]
        private Gtk.Button save_button;

        [GtkChild]
        private Gtk.MenuButton reencode_menu_button;

        [GtkChild]
        private Gtk.Popover reencode_popover;

        [GtkChild]
        private Gtk.ProgressBar bar;

        [GtkChild]
        private Gtk.Frame tags_frame;

        [GtkChild]
        private Gtk.Entry artist_entry;

        [GtkChild]
        private Gtk.Entry title_entry;

        [GtkChild]
        private Gtk.Entry album_entry;

        [GtkChild]
        private Gtk.Entry band_entry;

        [GtkChild]
        private Gtk.SpinButton year_spin_button;

        [GtkChild]
        private Gtk.Adjustment year_adjustment;

        [GtkChild]
        private Gtk.SpinButton disc_spin_button;

        [GtkChild]
        private Gtk.SpinButton track_spin_button;

        [GtkChild]
        private Gtk.SpinButton total_spin_button;

        [GtkChild]
        private Gtk.ComboBox genre_combobox;

        [GtkChild]
        private Gtk.Entry genre_entry;

        [GtkChild]
        private Gtk.ListStore genre_model;

        [GtkChild]
        private Gtk.Entry comment_entry;

        [GtkChild]
        private Gtk.Entry composer_entry;

        [GtkChild]
        private Gtk.Entry original_entry;

        [GtkChild]
        private Gtk.Image cover_image;

        [GtkChild]
        private Gtk.Image artist_image;

        [GtkChild]
        private Gtk.Image play_image;

        [GtkChild]
        private Gtk.Adjustment play_adjustment;

        [GtkChild]
        private Gtk.Label time_label;

        [GtkChild]
        private Gtk.Label filename_label;

        private bool ignore_popover;

        private Application mlm;

        private const string CSS_URI = "resource:///mx/unam/MLM/mlm.css";
        private const string ICON_NAME_CD = "media-optical-cd-audio-symbolic";
        private const string ICON_NAME_AVATAR = "avatar-default-symbolic";
        private const string ICON_NAME_PLAY = "media-playback-start-symbolic";
        private const string ICON_NAME_PAUSE = "media-playback-pause-symbolic";
        private const Gtk.IconSize ICON_SIZE = Gtk.IconSize.SMALL_TOOLBAR;

        public ApplicationWindow(Gtk.Application application) {
            GLib.Object(application: application);
            mlm = application as Application;

            Gtk.Window.set_default_icon_name("mlm");
            var provider = new Gtk.CssProvider();
            try {
                var file = GLib.File.new_for_uri(CSS_URI);
                provider.load_from_file(file);
            } catch (GLib.Error e) {
                stderr.printf("There was a problem loading ‘%s’\n", CSS_URI);
            }
            Gtk.StyleContext.add_provider_for_screen(Gdk.Screen.get_default(),
                                                      provider, 999);
            var date_time = new GLib.DateTime.now_local();
            year_adjustment.upper = date_time.get_year();

            reencode.bind_property("active", popover, "visible",
                                   GLib.BindingFlags.BIDIRECTIONAL);

            genre_model.set_sort_column_id(0, Gtk.SortType.ASCENDING);
        }

        [GtkCallback]
        public bool on_match_selected(Gtk.TreeModel m, Gtk.TreeIter i) {
            genre_combobox.set_active_iter(i);
            return true;
        }

        [GtkCallback]
        public void on_previous_clicked() {
            mlm.previous();
        }

        [GtkCallback]
        public void on_next_clicked() {
            mlm.next();
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
            mlm.set_artist_data(data);
            update_image(artist_image, data);
        }

        [GtkCallback]
        public void on_open_cover_clicked() {
            var data = select_image(_("Select image for cover"));
            mlm.set_cover_data(data);
            update_image(cover_image, data);
        }

        [GtkCallback]
        public void popover_visibility_changed() {
            if (!popover.visible) {
                mlm.stop_encoder();
            } else {
                progress_bar.set_fraction(0.0);
                mlm.start_encoder()
            }
        }

        [GtkCallback]
        public void on_save_clicked() {
            mlm.save();
            save.sensitive = false;
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

        public void upgrade_progress_bar(double percentage) {
            progress_bar.set_fraction(percentage);
        }

        public void hide_progress_bar() {
            ignore_popover = true;
            popover.visible = false;
            ignore_popover = false;
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
                mlm.play();
            } else {
                play_image.set_from_icon_name(ICON_NAME_PLAY, ICON_SIZE);
                mlm.pause();
            }
        }

        [GtkCallback]
        public void on_window_destroy() {
            mlm.quit();
        }

        [GtkCallback]
        public void tags_changed() {
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
                mlm.quit();
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

        public void warning(string message) {
            var dialog = new Gtk.MessageDialog(
                this, Gtk.DialogFlags.DESTROY_WITH_PARENT,
                Gtk.MessageType.WARNING, Gtk.ButtonsType.CLOSE,
                message);
            dialog.title = _("Warning");
            dialog.run();
            dialog.destroy();
        }

        private void set_default_image(Gtk.Image image) {
            if (image == cover_image)
                image.set_from_icon_name(ICON_NAME_CD, ICON_SIZE);
            else
                image.set_from_icon_name(ICON_NAME_AVATAR, ICON_SIZE);
            image.pixel_size = 140;
        }

        private void update_image(Gtk.Image image,
                                  uint8[]   data) {
            if (data == null)
                return;
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
                return;
            }
            image.set_from_pixbuf(thumb);
        }

        private bool dispose_player() {
            if (player == null || player.state == Gst.State.NULL) {
                player = new Player(filename);
                player.state_changed.connect(player_state_changed);
                return false;
            }
            return true;
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

        private void define_current(int c) {
            _current = c;
            header.set_subtitle("%d / %d".printf(_current, _last));
        }

        private void define_last(int l) {
            _last = l;
            header.set_subtitle("%d / %d".printf(_current, _last));
        }
    }
}
