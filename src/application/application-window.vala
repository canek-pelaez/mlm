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
     * MLM GUI application window class.
     */
    [GtkTemplate (ui = "/mx/unam/MLM/mlm.ui")]
    public class ApplicationWindow : Gtk.ApplicationWindow {

        /**
         * Play icon name.
         */
        public const string ICON_NAME_PLAY = "media-playback-start-symbolic";

        /**
         * Pause icon name.
         */
        public const string ICON_NAME_PAUSE = "media-playback-pause-symbolic";

        /* Cascade Style Sheet. */
        private const string CSS_URI = "resource:///mx/unam/MLM/mlm.css";
        /* CD icon name. */
        private const string ICON_NAME_CD = "media-optical-cd-audio-symbolic";
        /* Avatar icon name. */
        private const string ICON_NAME_AVATAR = "avatar-default-symbolic";
        /* Icon size. */
        private const Gtk.IconSize ICON_SIZE = Gtk.IconSize.SMALL_TOOLBAR;

        /* The header bar. */
        [GtkChild]
        private Gtk.HeaderBar header_bar;

        /* The previous button. */
        [GtkChild]
        private Gtk.Button previous_button;

        /* The next button. */
        [GtkChild]
        private Gtk.Button next_button;

        /* The save button. */
        [GtkChild]
        private Gtk.Button save_button;

        /* The encode menu button. */
        [GtkChild]
        private Gtk.MenuButton encode_menu_button;

        /* The encode popover. */
        [GtkChild]
        private Gtk.Popover encode_popover;

        /* The encode progress bar. */
        [GtkChild]
        private Gtk.ProgressBar encode_progress_bar;

        /* The tags frame. */
        [GtkChild]
        private Gtk.Frame tags_frame;

        /* The artist entry. */
        [GtkChild]
        private Gtk.Entry artist_entry;

        /* The title entry. */
        [GtkChild]
        private Gtk.Entry title_entry;

        /* The album entry. */
        [GtkChild]
        private Gtk.Entry album_entry;

        /* The band entry. */
        [GtkChild]
        private Gtk.Entry band_entry;

        /* The year spin button. */
        [GtkChild]
        private Gtk.SpinButton year_spin_button;

        /* The year adjustment. */
        [GtkChild]
        private Gtk.Adjustment year_adjustment;

        /* The disc spin button. */
        [GtkChild]
        private Gtk.SpinButton disc_spin_button;

        /* The track spin button. */
        [GtkChild]
        private Gtk.SpinButton track_spin_button;

        /* The total spin button. */
        [GtkChild]
        private Gtk.SpinButton total_spin_button;

        /* The genre combo box. */
        [GtkChild]
        private Gtk.ComboBox genre_combo_box;

        /* The genre entry. */
        [GtkChild]
        private Gtk.Entry genre_entry;

        /* The genre model. */
        [GtkChild]
        private Gtk.ListStore genre_model;

        /* The comment entry. */
        [GtkChild]
        private Gtk.Entry comment_entry;

        /* The composer entry. */
        [GtkChild]
        private Gtk.Entry composer_entry;

        /* The original entry. */
        [GtkChild]
        private Gtk.Entry original_entry;

        /* The cover image. */
        [GtkChild]
        private Gtk.Image cover_image;

        /* The artist image. */
        [GtkChild]
        private Gtk.Image artist_image;

        /* The play image. */
        [GtkChild]
        private Gtk.Image play_image;

        /* The play adjustment. */
        [GtkChild]
        private Gtk.Adjustment play_adjustment;

        /* The time label. */
        [GtkChild]
        private Gtk.Label time_label;

        /* The filename label. */
        [GtkChild]
        private Gtk.Label filename_label;

        /* The MLM application. */
        private Application mlm;
        /* The file tags. */
        private FileTags tags;
        /* Whether the UI is in flux. */
        private bool ui_in_flux;

        /**
         * Initializes the application window.
         * @param application the application.
         */
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
            encode_menu_button.bind_property(
                "active", encode_popover,
                "visible", GLib.BindingFlags.BIDIRECTIONAL);
            genre_model.set_sort_column_id(0, Gtk.SortType.ASCENDING);
        }

        /* The on match selected callback. */
        [GtkCallback]
        private bool on_match_selected(Gtk.TreeModel m, Gtk.TreeIter i) {
            genre_combo_box.set_active_iter(i);
            return true;
        }

        /* The on previous clicked callback. */
        [GtkCallback]
        private void on_previous_clicked() {
            mlm.activate_action("prev", null);
        }

        /* The on next clicked callback. */
        [GtkCallback]
        private void on_next_clicked() {
            mlm.activate_action("next", null);
        }

        /* The on popover visibility changed callback. */
        [GtkCallback]
        private void on_popover_visibility_changed() {
            if (!encode_popover.visible)
                mlm.activate_action("stop-encoder", null);
            else
                mlm.activate_action("start-encoder", null);
        }

        /* The on save clicked callback. */
        [GtkCallback]
        private void on_save_clicked() {
            mlm.activate_action("save", null);
        }

        /* The on play clicked callback. */
        [GtkCallback]
        private void on_play_clicked() {
            mlm.activate_action("play", null);
        }

        /* The on open artist image clicked callback. */
        [GtkCallback]
        private void on_open_artist_image_clicked() {
            var data = select_image(_("Select image for artist"));
            if (data == null)
                return;
            tags.artist_picture = data;
            update_image(artist_image, data);
        }

        /* The on clear artist image clicked callback. */
        [GtkCallback]
        private void on_clear_artist_image_clicked() {
            tags.artist_picture = null;
            set_default_image(artist_image);
        }

        /* The on open cover image clicked callback. */
        [GtkCallback]
        private void on_open_cover_image_clicked() {
            var data = select_image(_("Select image for cover"));
            if (data == null)
                return;
            tags.cover_picture = data;
            update_image(cover_image, data);
        }

        /* The on clear cover image clicked callback. */
        [GtkCallback]
        private void on_clear_cover_image_clicked() {
            tags.cover_picture = null;
            set_default_image(cover_image);
        }

        /* The on scale change callback. */
        [GtkCallback]
        private bool on_scale_change_value(Gtk.ScrollType scroll, double value) {
            if (value < 0.0)
                value = 0.0;
            if (value > 1.0)
                value = 1.0;
            if (!mlm.seek_player(value)) {
                reset_timer();
                return true;
            }
            return false;
        }

        /* The on window destroy callback. */
        [GtkCallback]
        private void on_window_destroy() {
            mlm.activate_action("quit", null);
        }

        /* The on tags changed callback. */
        [GtkCallback]
        private void on_tags_changed() {
            if (ui_in_flux)
                return;
            tags.artist = artist_entry.text != "" ? artist_entry.text : null;
            tags.title = title_entry.text != "" ? title_entry.text : null;
            tags.album = album_entry.text != "" ? album_entry.text : null;
            tags.band = band_entry.text != "" ? band_entry.text : null;
            tags.year = (int)year_spin_button.value;
            tags.disc = (int)disc_spin_button.value;
            tags.track = (int)track_spin_button.value;
            tags.total = (int)total_spin_button.value;
            tags.genre = genre_entry.text != "" ?
                Genre.index_of(genre_entry.text) : -1;
            tags.comment = comment_entry.text != "" ?
                comment_entry.text : null;
            tags.composer = composer_entry.text != "" ?
                composer_entry.text : null;
            tags.original = original_entry.text != "" ?
                original_entry.text : null;
            save_button.sensitive = true;
        }

        /**
         * Updates the encoding popover.
         * @param percentage the percentage of the encoding.
         */
        public void update_encoding(double percentage) {
            if (percentage < 0.0)
                encode_popover.visible = false;
            else
                encode_progress_bar.set_fraction(percentage);
        }

        /**
         * Updates the player view.
         * @param percentage the percentage of the player.
         * @param time the player time string.
         */
        public void update_player_view(double percentage, string time) {
            play_adjustment.set_value(percentage);
            time_label.set_text(time);
        }

        /**
         * Sets the play icon.
         */
        public void set_play_icon(string name) {
            play_image.set_from_icon_name(name, ICON_SIZE);
        }

        /**
         * Enables the UI.
         */
        public void enable_ui(bool enable) {
            encode_menu_button.sensitive =
            previous_button.sensitive =
            next_button.sensitive =
            save_button.sensitive =
            tags_frame.sensitive = enable;
        }

        /**
         * Updates the view.
         * @param filename the filename.
         * @param tags the tags.
         * @param current the current file index.
         * @param total the total number of files.
         */
        public void update_view(string filename, FileTags tags,
                                int current, int total) {
            this.tags = tags;
            tags.updated.connect(() => save_button.sensitive = false);

            header_bar.set_subtitle("%d / %d".printf(current, total));
            var basename = GLib.Path.get_basename(filename);
            var markup = GLib.Markup.printf_escaped("<b>%s</b>", basename);
            filename_label.set_markup(markup);
            previous_button.sensitive = current != 1;
            next_button.sensitive = current < total;
            save_button.sensitive = false;
            reset_timer();

            ui_in_flux = true;
            artist_entry.text = tags.artist != null ? tags.artist : "";
            title_entry.text = tags.title != null ? tags.title : "";
            album_entry.text = tags.album != null ? tags.album : "";
            band_entry.text = tags.band != null ? tags.band : "";
            year_spin_button.value = tags.year != -1 ? tags.year : 1900;
            disc_spin_button.value = tags.disc != -1 ? tags.disc : 1;
            track_spin_button.value = tags.track != -1 ? tags.track : 1;
            total_spin_button.value = tags.total != -1 ? tags.total : 1;
            genre_entry.text =
                 (tags.genre >= 0 && tags.genre < Genre.total()) ?
                Genre.all()[tags.genre].to_string() : "";
            comment_entry.text = tags.comment != null ? tags.comment : "";
            composer_entry.text = tags.composer != null ? tags.composer : "";
            original_entry.text = tags.original != null ? tags.original : "";
            update_image(cover_image, tags.cover_picture);
            update_image(artist_image, tags.artist_picture);
            ui_in_flux = false;
        }

        /* Resets the timer. */
        private void reset_timer() {
            play_image.set_from_icon_name(ICON_NAME_PLAY, ICON_SIZE);
            play_adjustment.set_value(0.0);
            time_label.set_text("00:00");
        }

        /* Selects an image from a file. */
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
                var bn = GLib.Path.get_basename(fn);
                var m = _("There was an error loading image '%s'").printf(bn);
                show_warning(m);
            }
            return null;
        }

        /* Sets a default image. */
        private void set_default_image(Gtk.Image image) {
            if (image == cover_image)
                image.set_from_icon_name(ICON_NAME_CD, ICON_SIZE);
            else
                image.set_from_icon_name(ICON_NAME_AVATAR, ICON_SIZE);
            image.pixel_size = 140;
            save_button.sensitive = true;
        }

        /* Updates an image. */
        private void update_image(Gtk.Image image, uint8[] data) {
            if (data == null) {
                set_default_image(image);
                return;
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
                show_warning(_("Could not set pixbuf from data."));
                set_default_image(image);
                return;
            }
            save_button.sensitive = true;
            image.set_from_pixbuf(thumb);
        }

        /* Shows a warning dialog. */
        private void show_warning(string message) {
            var dialog = new WarningDialog(this, message);
            dialog.run();
            dialog.destroy();
        }
    }
}
