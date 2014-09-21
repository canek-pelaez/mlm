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
        private Gtk.Button reencode;

        [GtkChild]
        private Gtk.Frame frame;

        [GtkChild]
        private Gtk.Button save;

        [GtkChild (name = "filename")]
        private Gtk.Label filename_widget;
        private string _filename;
        public string filename {
            get { return _filename; }
            set {
                _filename = value;
                var basename = GLib.Path.get_basename(filename);
                var markup = GLib.Markup.printf_escaped("<b>%s</b>", basename);
                filename_widget.set_markup(markup);
                if (player != null)
                    player.pause();
                reset_timer();
                player = new Player(value);
                player.status_changed.connect(player_status_changed);
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
            set {
                int i = Genre.index_of(value);
                if (i != -1) {
                    genre_combobox.active = i;
                    //genre_widget.set_text(value);
                }
            }
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
            set { _cover_data = update_image(cover_image, value); }
        }

        [GtkChild]
        private Gtk.Image artist_image;

        public uint8[] _artist_data;
        public uint8[] artist_data {
            get { return _artist_data; }
            set { _artist_data = update_image(artist_image, value); }
        }

        [GtkChild]
        private Gtk.Image play_image;

        [GtkChild]
        private Gtk.Adjustment play_adjustment;

        [GtkChild]
        private Gtk.Label time;

        private Gtk.Dialog progress;
        private Gtk.ProgressBar progress_bar;

        private Application app;
        private Player player;
        private Encoder encoder;

        private static const string ICON_NAME_CD = "media-optical-cd-audio-symbolic";
        private static const string ICON_NAME_AVATAR = "avatar-default-symbolic";
        private static const string ICON_NAME_PLAY = "media-playback-start-symbolic";
        private static const string ICON_NAME_PAUSE = "media-playback-pause-symbolic";
        private static const Gtk.IconSize ICON_SIZE = Gtk.IconSize.SMALL_TOOLBAR;

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
            genre_widget.completion.match_selected.connect((m, i) => {
                    genre_combobox.set_active_iter(i);
                    return true;
                });

            _cover_data = null;
            _artist_data = null;
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
        public void on_reencode_clicked() {
            int cont = 0;
            string dest = "";
            do {
                string d = Path.get_dirname(filename);
                string s = GLib.Path.DIR_SEPARATOR_S;
                string a = artist.replace("/", "_");
                string t = title_.replace("/", "_");
                string e = (cont == 0) ? ".mp3" : "-%d.mp3".printf(cont);
                dest = d + s + a + " - " + t + e;
                cont++;
            } while (GLib.FileUtils.test(dest, GLib.FileTest.EXISTS));
            encoder = new Encoder(filename, dest);
            encoder.encode();
            create_progress_dialog(dest);
            GLib.Idle.add(upgrade_progressbar);
            if (progress.run() != Gtk.ResponseType.OK) {
                encoder.cancel();
                GLib.FileUtils.remove(dest);
            } else {
                app.set_tags_in_file(dest);
            }
            progress.destroy();
        }

        [GtkCallback]
        public void on_save_clicked() {
            app.save();
            save.sensitive = false;
        }

        private void create_progress_dialog(string dest) {
            progress = new Gtk.Dialog.with_buttons(
                _("Reencoding"), this, Gtk.DialogFlags.MODAL,
                _("_Cancel"), Gtk.ResponseType.CANCEL);
            var label = new Gtk.Label(_("Reencoding '%s'\ninto '%s'... ").printf
                                    (GLib.Path.get_basename(filename),
                                     GLib.Path.get_basename(dest)));
            progress_bar = new Gtk.ProgressBar();
            var vbox = new Gtk.Box(Gtk.Orientation.VERTICAL, 6);
            vbox.pack_start(label);
            vbox.pack_start(progress_bar);
            var content = progress.get_content_area();
            content.margin = 6;
            content.spacing = 6;
            content.pack_start(vbox);
            progress.show_all();
        }

        private bool upgrade_progressbar() {
            double p = encoder.get_completion();
            progress_bar.set_fraction(p);
            if (p < 1.0)
                return true;
            progress.response(Gtk.ResponseType.OK);
            return false;
        }

        private void player_status_changed(Player.Status status) {
            switch (status) {
            case Player.Status.PLAYING:
                play_image.set_from_icon_name(ICON_NAME_PAUSE, ICON_SIZE);
                GLib.Idle.add(monitor_play);
                break;
            case Player.Status.PAUSED:
                play_image.set_from_icon_name(ICON_NAME_PLAY, ICON_SIZE);
                break;
            case Player.Status.RESET:
                reset_timer();
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

        private uint8[] update_image(Gtk.Image image, uint8[] data) {
            if (data == null) {
                set_default_image(image);
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
                warning(_("Could not set pixbuf from data."));
                set_default_image(image);
                uint8[] r = null;
                return r;
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