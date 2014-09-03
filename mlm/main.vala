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

    public class Main {

        // private int current_year;
        // private Genre[] genres;
        // private HashMap<string, int> genre_map;
        // private ArrayList<string> files;
        // private Iterator<string> iterator;
        // private FileTags file_tags;

        // private Window window;
        // private Label frame_label;

        // private Dialog progress;
        // private ProgressBar progress_bar;
        // private Encoder encoder;
        // private bool encoding_cancelled;

        // private bool transitioning;
        // private bool updating_tracks;
        // private bool album_mode;

        // private string filename;
        // private string dest;

        // public Main(ArrayList<string> files) {

        //     if (files.size == 0) {
        //         window.set_sensitive(false);
        //         return;
        //     }

        //     artist_entry.changed.connect(() => { update_artist(); });
        //     title_entry.changed.connect(() => { update_title(); });
        //     album_entry.changed.connect(() => { update_album(); });
        //     year_spin.value_changed.connect(() => { update_year(); });
        //     track_number_spin.value_changed.connect(() => { update_track_number(); });
        //     track_count_spin.value_changed.connect(() => { update_track_count(); });
        //     disc_spin.value_changed.connect(() => { update_disc(); });
        //     genre_combo.changed.connect(() => { update_genre(); });
        //     comment_entry.changed.connect(() => { update_comment(); });
        //     composer_entry.changed.connect(() => { update_composer(); });
        //     original_entry.changed.connect(() => { update_original(); });

        //     Button button = builder.get_object("cover_open_button") as Button;
        //     button.clicked.connect(() => { select_cover_image(); });
        //     button = builder.get_object("cover_clear_button") as Button;
        //     button.clicked.connect(() => { clear_cover_image(); });
        //     button = builder.get_object("artist_open_button") as Button;
        //     button.clicked.connect(() => { select_artist_image(); });
        //     button = builder.get_object("artist_clear_button") as Button;
        //     button.clicked.connect(() => { clear_artist_image(); });
        //     button = builder.get_object("reencode_button") as Button;
        //     button.clicked.connect(() => { reencode(); });
        //     button = builder.get_object("update_tags_button") as Button;
        //     button.clicked.connect(() => { update_tags(); });
        //     CheckButton check = builder.get_object("album_mode_checkbutton") as CheckButton;
        //     check.toggled.connect((c) => { album_mode = c.get_mode(); });

        //     iterator = files.iterator();

        //     next_filename();
        // }

        // private void update_artist() {
        //     if (transitioning)
        //         return;
        //     file_tags.update_artist(artist_entry.get_text());
        // }

        // private void update_title() {
        //     if (transitioning)
        //         return;
        //     file_tags.update_title(title_entry.get_text());
        // }

        // private void update_album() {
        //     if (transitioning)
        //         return;
        //     file_tags.update_album(album_entry.get_text());
        // }

        // private void update_year() {
        //     if (transitioning)
        //         return;
        //     file_tags.update_year((int)year_spin.get_value());
        // }

        // private void update_track_number() {
        //     if (transitioning)
        //         return;
        //     if (updating_tracks)
        //         return;
        //     updating_tracks = true;
        //     int tn = (int)track_number_spin.get_value();
        //     int tc = file_tags.track_count;
        //     if (tn > tc) {
        //         tc = tn;
        //         track_count_spin.set_value(tc);
        //     }
        //     file_tags.update_track(tn, tc);
        //     updating_tracks = false;
        // }

        // private void update_track_count() {
        //     if (transitioning)
        //         return;
        //     if (updating_tracks)
        //         return;
        //     updating_tracks = true;
        //     int tn = file_tags.track_number;
        //     int tc = (int)track_count_spin.get_value();
        //     if (tn > tc) {
        //         tn = tc;
        //         track_number_spin.set_value(tn);
        //     }
        //     file_tags.update_track(tn, tc);
        //     updating_tracks = false;
        // }

        // private void update_track() {
        //     int tn = (int)track_number_spin.get_value();
        //     int tc = (int)track_count_spin.get_value();
        //     file_tags.update_track(tn, tc);
        // }

        // private void update_disc() {
        //     if (transitioning)
        //         return;
        //     file_tags.update_disc_number((int)disc_spin.get_value());
        // }

        // private void update_genre() {
        //     if (transitioning)
        //         return;
        //     string g = genre_entry.get_text();
        //     if (!genre_map.has_key(g))
        //         return;
        //     file_tags.update_genre(genre_map[g]);
        // }

        // private void update_comment() {
        //     if (transitioning)
        //         return;
        //     file_tags.update_comment(comment_entry.get_text());
        // }

        // private void update_composer() {
        //     if (transitioning)
        //         return;
        //     file_tags.update_composer(composer_entry.get_text());
        // }

        // private void update_original() {
        //     if (transitioning)
        //         return;
        //     file_tags.update_original_artist(original_entry.get_text());
        // }

        // private void clear_slate() {
        //     transitioning = true;
        //     artist_entry.set_text("");
        //     title_entry.set_text("");
        //     album_entry.set_text("");
        //     year_spin.set_value(current_year);
        //     track_number_spin.set_value(1);
        //     track_count_spin.set_value(1);
        //     disc_spin.set_value(1);
        //     genre_entry.set_text("");
        //     comment_entry.set_text("");
        //     composer_entry.set_text("");
        //     original_entry.set_text("");
        //     cover_image.set_from_pixbuf(no_cover);
        //     artist_image.set_from_pixbuf(no_artist);
        //     transitioning = false;
        // }

        // private void next_filename() {
        //     if (!iterator.has_next()) {
        //         Gtk.main_quit();
        //         return;
        //     }
        //     iterator.next();
        //     clear_slate();
        //     filename = iterator.get();
        //     frame_label.set_markup("<b>" + Path.get_basename(filename) + "</b>");
        //     file_tags = new FileTags(filename);
        //     if (file_tags.artist != null)
        //         artist_entry.set_text(file_tags.artist);
        //     if (file_tags.title != null)
        //         title_entry.set_text(file_tags.title);
        //     if (file_tags.album != null)
        //         album_entry.set_text(file_tags.album);
        //     if (file_tags.year != -1)
        //         year_spin.set_value(file_tags.year);
        //     else
        //         year_spin.set_value(1900);
        //     if (file_tags.track_number != -1)
        //         track_number_spin.set_value(file_tags.track_number);
        //     else
        //         track_number_spin.set_value(1);
        //     if (file_tags.track_count != -1)
        //         track_count_spin.set_value(file_tags.track_count);
        //     else
        //         track_count_spin.set_value(1);
        //     if (file_tags.disc_number != -1)
        //         disc_spin.set_value(file_tags.disc_number);
        //     else
        //         disc_spin.set_value(1);
        //     if (file_tags.genre != -1)
        //         genre_entry.set_text(genres[file_tags.genre].to_string());
        //     else
        //         genre_entry.set_text(genres[0].to_string());
        //     if (file_tags.comment != null)
        //         comment_entry.set_text(file_tags.comment);
        //     if (file_tags.composer != null)
        //         composer_entry.set_text(file_tags.composer);
        //     if (file_tags.original_artist != null)
        //         original_entry.set_text(file_tags.original_artist);
        //     if (file_tags.front_cover_picture != null)
        //         set_image_from_data(cover_image, file_tags.front_cover_picture);
        //     else
        //         cover_image.set_from_pixbuf(no_cover);
        //     if (file_tags.artist_picture != null)
        //         set_image_from_data(artist_image, file_tags.artist_picture);
        //     else
        //         artist_image.set_from_pixbuf(no_artist);
        // }

        // private void set_image_from_data(Image image, uint8[] data) {
        //     var mis = new MemoryInputStream.from_data(data, null);
        //     try {
        //         var pixbuf = new Gdk.Pixbuf.from_stream(mis);
        //         double scale = 150.0 / double.max(pixbuf.width, pixbuf.height);
        //         pixbuf = pixbuf.scale_simple((int)(pixbuf.width*scale),
        //                                      (int)(pixbuf.height*scale),
        //                                      Gdk.InterpType.BILINEAR);

        //         image.set_from_pixbuf(pixbuf);
        //     } catch (Error e) {
        //         stderr.printf("Could not set pixbuf from data.\n");
        //     }
        // }

        // private uint8[]? get_picture_data() {
        //     FileChooserDialog dialog;
        //     dialog = new FileChooserDialog("Select image file",
        //                                    window, FileChooserAction.OPEN,
        //                                    _("_Cancel"), ResponseType.CANCEL,
        //                                    _("_Open"), ResponseType.ACCEPT);
        //     int r = dialog.run();
        //     string fn = dialog.get_filename();
        //     dialog.destroy();
        //     if (r != ResponseType.ACCEPT)
        //         return null;
        //     try {
        //         uint8[] bytes;
        //         FileUtils.get_data(fn, out bytes);
        //         return bytes;
        //     } catch (FileError fe) {
        //         stderr.printf("There was an error reading from '%s'.\n", fn);
        //     }
        //     return null;
        // }

        // private void select_cover_image() {
        //     uint8[] data = get_picture_data();
        //     if (data == null)
        //         return;
        //     set_image_from_data(cover_image, data);
        //     file_tags.update_front_cover_picture(data);
        // }

        // private void clear_cover_image() {
        //     cover_image.set_from_pixbuf(no_cover);
        //     file_tags.update_front_cover_picture(null);
        // }

        // private void select_artist_image() {
        //     uint8[] data = get_picture_data();
        //     if (data == null)
        //         return;
        //     set_image_from_data(artist_image, data);
        //     file_tags.update_artist_picture(data);
        // }

        // private void clear_artist_image() {
        //     artist_image.set_from_pixbuf(no_artist);
        //     file_tags.update_artist_picture(null);
        // }

        // private void create_progress_dialog() {
        //     progress = new Dialog.with_buttons(
        //         _("Reencoding"), window, DialogFlags.MODAL,
        //         _("_Cancel"), ResponseType.CANCEL);
        //     progress.border_width = 6;
        //     Label label = new Label(_("Reencoding '%s'\ninto '%s'... ").printf
        //                             (Path.get_basename(filename),
        //                              Path.get_basename(dest)));
        //     progress_bar = new ProgressBar();
        //     Box vbox = new Box(Orientation.VERTICAL, 6);
        //     vbox.pack_start(label);
        //     vbox.pack_start(new Separator(Orientation.HORIZONTAL));
        //     vbox.pack_start(progress_bar);
        //     Image icon = new Image.from_icon_name("dialog-information",
        //                                           IconSize.DIALOG);
        //     Box hbox = new Box(Orientation.HORIZONTAL, 6);
        //     hbox.pack_start(icon);
        //     hbox.pack_start(vbox);
        //     Box content = progress.get_content_area();
        //     content.set_spacing(6);
        //     content.pack_start(hbox);
        // }

        // private bool upgrade_progressbar() {
        //     double p = encoder.get_completion_percentage();
        //     progress_bar.set_fraction(p);

        //     if (p < 1.0)
        //         return true;

        //     if (encoding_cancelled) {
        //         encoding_cancelled = false;
        //         FileUtils.remove(dest);
        //         return false;
        //     }

        //     uint8[] cp = file_tags.front_cover_picture;
        //     uint8[] ap = file_tags.artist_picture;

        //     file_tags = new FileTags(dest);
        //     update_artist();
        //     update_title();
        //     update_album();
        //     update_year();
        //     update_track();
        //     update_disc();
        //     update_genre();
        //     update_comment();
        //     update_composer();
        //     update_original();
        //     file_tags.update_front_cover_picture(cp);
        //     file_tags.update_artist_picture(ap);
        //     file_tags.update();

        //     progress.response(ResponseType.OK);

        //     return false;
        // }

        // private void reencode() {
        //     dest = Path.get_dirname(filename) + Path.DIR_SEPARATOR_S;
        //     if (album_mode && file_tags.track_number != -1)
        //         dest += "%02d - ".printf(file_tags.track_number);
        //     if (file_tags.artist != null)
        //         dest += file_tags.artist.replace("/", "_");
        //     dest += " - ";
        //     if (file_tags.title != null)
        //         dest += file_tags.title.replace("/", "_");
        //     dest += ".mp3";
        //     if (FileUtils.test(dest, FileTest.EXISTS)) {
        //         MessageDialog dialog;
        //         dialog = new MessageDialog(
        //             window, DialogFlags.DESTROY_WITH_PARENT,
        //             MessageType.QUESTION, ButtonsType.YES_NO,
        //             _("The file '%s' already exists.\nRewrite it?"),
        //             Path.get_basename(dest));
        //         int r = dialog.run();
        //         dialog.destroy();
        //         if (r != ResponseType.YES)
        //             return;
        //     }
        //     encoder = new Encoder(filename, dest);
        //     if (!encoder.encode()) {
        //         MessageDialog dialog;
        //         dialog = new MessageDialog(
        //             window, DialogFlags.DESTROY_WITH_PARENT,
        //             MessageType.INFO, ButtonsType.OK,
        //             _("There was an error while\nreencoding file '%s'.\n"),
        //             Path.get_basename(filename));
        //         dialog.run();
        //         dialog.destroy();
        //         return;
        //     }
        //     create_progress_dialog();
        //     progress.show_all();
        //     Idle.add(upgrade_progressbar);
        //     int r = progress.run();
        //     if (r != ResponseType.OK) {
        //         encoder.cancel();
        //         encoding_cancelled = true;
        //     }
        //     progress.destroy();
        //     if (r == ResponseType.OK) {
        //         next_filename();
        //     }
        // }

        // private void update_tags() {
        //     file_tags.update();
        //     next_filename();
        // }

        // public void start() {
        //     window.show_all();
        // }

        public static int main(string[] args) {
            Intl.bindtextdomain(Config.GETTEXT_PACKAGE, Config.LOCALEDIR);
            Intl.bind_textdomain_codeset(Config.GETTEXT_PACKAGE, "UTF-8");
            Intl.textdomain(Config.GETTEXT_PACKAGE);
            GLib.Environment.set_application_name("MLM");
            Gtk.init(ref args);
            //Gst.init(ref args);

            var mlm = new Application();
            mlm.run(args);

            return 0;
        }
    }
}
