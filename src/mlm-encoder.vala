using Gee;
using Gtk;

namespace MLM {

    public class Encoder {

        private static int current_year;
        private static const string UI = "data/mlm-encoder.ui";

        private Genre[] genres;
        private HashMap<string, int> genre_map;
        private ArrayList<string> files;
        private Iterator<string> iterator;
        private FileTags file_tags;

        private Window window;
        private Label frame_label;

        private Entry artist_entry;
        private Entry title_entry;
        private Entry album_entry;
        private SpinButton year_spin;
        private SpinButton track_number_spin;
        private SpinButton track_count_spin;
        private SpinButton disc_spin;
        private ComboBox genre_combo;
        private Entry genre_entry;
        private Entry comment_entry;
        private Entry composer_entry;
        private Entry original_entry;
        private Image cover_image;
        private Image artist_image;

        private static Gdk.Pixbuf no_cover;
        private static Gdk.Pixbuf no_artist;

        private Dialog progress;
        private ProgressBar progress_bar;
        private Gst.Pipeline pipe;
        private bool reencoding;

        private bool updating_tracks;
        private bool album_mode;

        private string filename;
        private string dest;

        public Encoder(ArrayList<string> files) {
            genres = Genre.all();
            genre_map = new HashMap<string, int>();
            for (int i = 0; i < genres.length; i++)
                genre_map[genres[i].to_string()] = i;
            updating_tracks = false;
            album_mode = false;
            this.files = files;
            var builder = new Builder();
            try {
                builder.add_from_file(UI);
            } catch (Error e) {
                error("Could not open UI file '%s'.", UI);
            }
            window = builder.get_object("window") as Window;
            frame_label = builder.get_object("frame_label") as Label;
            artist_entry = builder.get_object("artist_entry") as Entry;
            title_entry = builder.get_object("title_entry") as Entry;
            album_entry = builder.get_object("album_entry") as Entry;
            year_spin = builder.get_object("year_spinbutton") as SpinButton;
            track_number_spin = builder.get_object("track_number_spinbutton") as SpinButton;
            track_count_spin = builder.get_object("track_count_spinbutton") as SpinButton;
            disc_spin = builder.get_object("disc_spinbutton") as SpinButton;
            genre_combo = builder.get_object("genre_comboboxtext") as ComboBox;
            genre_entry = builder.get_object("genre_entry") as Entry;
            comment_entry = builder.get_object("comment_entry") as Entry;
            composer_entry = builder.get_object("composer_entry") as Entry;
            original_entry = builder.get_object("original_entry") as Entry;
            cover_image = builder.get_object("cover_image") as Image;
            artist_image = builder.get_object("artist_image") as Image;

            no_cover = cover_image.get_pixbuf();
            no_artist = artist_image.get_pixbuf();

            window.window_position = WindowPosition.CENTER_ALWAYS;
            window.destroy.connect(Gtk.main_quit);

            if (files.size == 0) {
                window.set_sensitive(false);
                return;
            }

            year_spin.adjustment.upper = current_year;

            artist_entry.changed.connect(() => { update_artist(); });
            title_entry.changed.connect(() => { update_title(); });
            album_entry.changed.connect(() => { update_album(); });
            year_spin.value_changed.connect(() => { update_year(); });
            track_number_spin.value_changed.connect(() => { update_track_number(); });
            track_count_spin.value_changed.connect(() => { update_track_count(); });
            disc_spin.value_changed.connect(() => { update_disc(); });
            genre_combo.changed.connect(() => { update_genre(); });
            comment_entry.changed.connect(() => { update_comment(); });
            composer_entry.changed.connect(() => { update_composer(); });
            original_entry.changed.connect(() => { update_original(); });

            /* Stupid GtkBuilder. */
            EntryCompletion completion = new EntryCompletion();
            completion.set_model(genre_combo.get_model());
            completion.inline_completion = true;
            completion.set_text_column(0);
            genre_entry.set_completion(completion);

            Button button = builder.get_object("cover_open_button") as Button;
            button.clicked.connect(() => { select_cover_image(); });
            button = builder.get_object("cover_clear_button") as Button;
            button.clicked.connect(() => { clear_cover_image(); });
            button = builder.get_object("artist_open_button") as Button;
            button.clicked.connect(() => { select_artist_image(); });
            button = builder.get_object("artist_clear_button") as Button;
            button.clicked.connect(() => { clear_artist_image(); });
            button = builder.get_object("reencode_button") as Button;
            button.clicked.connect(() => { reencode(); });
            button = builder.get_object("update_tags_button") as Button;
            button.clicked.connect(() => { update_tags(); });
            CheckButton check = builder.get_object("album_mode_checkbutton") as CheckButton;
            check.toggled.connect((c) => { album_mode = c.get_mode(); });

            iterator = files.iterator();

            next_filename();
        }

        private void update_artist() {
            file_tags.update_artist(artist_entry.get_text());
        }

        private void update_title() {
            file_tags.update_title(title_entry.get_text());
        }

        private void update_album() {
            file_tags.update_album(album_entry.get_text());
        }

        private void update_year() {
            file_tags.update_year((int)year_spin.get_value());
        }

        private void update_track_number() {
            if (updating_tracks)
                return;
            updating_tracks = true;
            int tn = (int)track_number_spin.get_value();
            int tc = file_tags.track_count;
            if (tn > tc) {
                tc = tn;
                track_count_spin.set_value(tc);
            }
            file_tags.update_track(tn, tc);
            updating_tracks = false;
        }

        private void update_track_count() {
            if (updating_tracks)
                return;
            updating_tracks = true;
            int tn = file_tags.track_number;
            int tc = (int)track_count_spin.get_value();
            if (tn > tc) {
                tn = tc;
                track_number_spin.set_value(tn);
            }
            file_tags.update_track(tn, tc);
            updating_tracks = false;
        }

        private void update_disc() {
            file_tags.update_disc_number((int)disc_spin.get_value());
        }

        private void update_genre() {
            string g = genre_entry.get_text();
            if (!genre_map.has_key(g))
                return;
            file_tags.update_genre(genre_map[g]);
        }

        private void update_comment() {
            file_tags.update_comment(comment_entry.get_text());
        }

        private void update_composer() {
            file_tags.update_composer(composer_entry.get_text());
        }

        private void update_original() {
            file_tags.update_original_artist(original_entry.get_text());
        }

        private void next_filename() {
            if (!iterator.has_next()) {
                Gtk.main_quit();
                return;
            }
            iterator.next();
            filename = iterator.get();
            frame_label.set_markup("<b>" + Path.get_basename(filename) + "</b>");
            file_tags = new FileTags(filename);
            if (file_tags.artist != null)
                artist_entry.set_text(file_tags.artist);
            if (file_tags.title != null)
                title_entry.set_text(file_tags.title);
            if (file_tags.album != null)
                album_entry.set_text(file_tags.album);
            if (file_tags.year != -1)
                year_spin.set_value(file_tags.year);
            else
                year_spin.set_value(1900);
            if (file_tags.track_number != -1)
                track_number_spin.set_value(file_tags.track_number);
            else
                track_number_spin.set_value(1);
            if (file_tags.track_count != -1)
                track_count_spin.set_value(file_tags.track_count);
            else
                track_count_spin.set_value(1);
            if (file_tags.disc_number != -1)
                disc_spin.set_value(file_tags.disc_number);
            else
                disc_spin.set_value(1900);
            if (file_tags.genre != -1)
                genre_entry.set_text(genres[file_tags.genre].to_string());
            else
                genre_entry.set_text(genres[0].to_string());
            if (file_tags.comment != null)
                comment_entry.set_text(file_tags.comment);
            if (file_tags.composer != null)
                composer_entry.set_text(file_tags.composer);
            if (file_tags.original_artist != null)
                original_entry.set_text(file_tags.original_artist);
            if (file_tags.front_cover_picture != null)
                set_image_from_data(cover_image, file_tags.front_cover_picture);
            else
                cover_image.set_from_pixbuf(no_cover);
            if (file_tags.artist_picture != null)
                set_image_from_data(artist_image, file_tags.artist_picture);
            else
                artist_image.set_from_pixbuf(no_artist);
        }

        private void set_image_from_data(Image image, uint8[] data) {
            MemoryInputStream mis = new MemoryInputStream.from_data(data, null);
            try {
                Gdk.Pixbuf pixbuf = new Gdk.Pixbuf.from_stream(mis);
                double scale = 150.0 / double.max(pixbuf.width, pixbuf.height);
                pixbuf = pixbuf.scale_simple((int)(pixbuf.width*scale),
                                             (int)(pixbuf.height*scale),
                                             Gdk.InterpType.BILINEAR);

                image.set_from_pixbuf(pixbuf);
            } catch (Error e) {
                stderr.printf("Could not set pixbuf from data.\n");
            }
        }

        private uint8[]? get_picture_data() {
            FileChooserDialog dialog;
            dialog = new FileChooserDialog("Select image file",
                                           window, FileChooserAction.OPEN,
                                           Stock.CANCEL, ResponseType.CANCEL,
                                           Stock.OPEN, ResponseType.ACCEPT);
            int r = dialog.run();
            if (r != ResponseType.ACCEPT) {
                dialog.destroy();
                return null;
            }
            string fn = dialog.get_filename();
            dialog.destroy();
            uint8[] bytes;
            try {
                FileUtils.get_data(fn, out bytes);
            } catch (FileError fe) {
                stderr.printf("There was an error reading from '%s'.\n", fn);
                return null;
            }
            return bytes;
        }

        private void select_cover_image() {
            uint8[] data = get_picture_data();
            if (data == null)
                return;
            set_image_from_data(cover_image, data);
            file_tags.update_front_cover_picture(data);
        }

        private void clear_cover_image() {
            cover_image.set_from_pixbuf(no_cover);
            file_tags.update_front_cover_picture(null);
        }

        private void select_artist_image() {
            uint8[] data = get_picture_data();
            if (data == null)
                return;
            set_image_from_data(artist_image, data);
            file_tags.update_artist_picture(data);
        }

        private void clear_artist_image() {
            artist_image.set_from_pixbuf(no_artist);
            file_tags.update_artist_picture(null);
        }

        private void create_progress_dialog() {
            progress = new Dialog.with_buttons("Reencoding", window,
                                                      DialogFlags.MODAL,
                                                      Stock.CANCEL,
                                                      ResponseType.CANCEL);
            progress.border_width = 6;
            Label label = new Label("Reencoding '%s'\ninto '%s'... ".printf
                                    (Path.get_basename(filename),
                                     Path.get_basename(dest)));
            progress_bar = new ProgressBar();
            Box vbox = new Box(Orientation.VERTICAL, 6);
            vbox.pack_start(label);
            vbox.pack_start(new Separator(Orientation.HORIZONTAL));
            vbox.pack_start(progress_bar);
            Image icon = new Image();
            icon.set_from_stock(Stock.DIALOG_INFO, IconSize.DIALOG);
            Box hbox = new Box(Orientation.HORIZONTAL, 6);
            hbox.pack_start(icon);
            hbox.pack_start(vbox);
            Box content = progress.get_content_area();
            content.set_spacing(6);
            content.pack_start(hbox);
        }

        private bool upgrade_progressbar() {
            double p = get_reencoding_percentage();
            progress_bar.set_fraction(p);

            if (p < 1.0)
                return true;

            uint8[] cp = file_tags.front_cover_picture;
            uint8[] ap = file_tags.artist_picture;

            file_tags = new FileTags(dest);
            update_artist();
            update_title();
            update_album();
            update_year();
            update_track_number();
            update_track_count();
            update_disc();
            update_genre();
            update_comment();
            update_composer();
            update_original();
            file_tags.update_front_cover_picture(cp);
            file_tags.update_artist_picture(ap);
            file_tags.update();

            progress.response(ResponseType.OK);

            return false;
        }

        private double get_reencoding_percentage() {
            Gst.State state;
            Gst.State pending;

            pipe.get_state(out state, out pending, 100);

            if (state != Gst.State.PLAYING)
                return 1.0;

            int64 duration = -1;
            Gst.Format format = Gst.Format.TIME;
            while (duration == -1)
                if (!pipe.query_duration(format, out duration))
                    duration = -1;
            int64 pos = -1;
            while (pos == -1)
                if (!pipe.query_position(format, out pos))
                    pos = -1;
            return (double)pos/(double)duration;
        }

        private void start_pipeline() {
            pipe = new Gst.Pipeline("pipe");
            pipe.set_state(Gst.State.PAUSED);
            var src = Gst.ElementFactory.make("filesrc", "source");
            src.set_property("location", filename);
            var mad = Gst.ElementFactory.make("mad", "mad");
            var ac1 = Gst.ElementFactory.make("audioconvert", "ac1");
            var rgl = Gst.ElementFactory.make("rglimiter", "rgl");
            var ac2 = Gst.ElementFactory.make("audioconvert", "ac2");
            var lame = Gst.ElementFactory.make("lamemp3enc", "lame");
            lame.set_property("bitrate", 128);
            lame.set_property("cbr", true);
            var sink = Gst.ElementFactory.make("filesink", "sink");
            sink.set_property("location", dest);
            pipe.add(src);
            pipe.add(mad);
            pipe.add(ac1);
            pipe.add(rgl);
            pipe.add(ac2);
            pipe.add(lame);
            pipe.add(sink);
            src.link_many(mad, ac1, rgl, ac2, lame, sink);

            var bus = pipe.get_bus();
            bus.add_signal_watch();
            bus.message.connect((b,m) => { message_received(m); });
        }

        private bool change_pipeline_state(Gst.State new_state) {
            pipe.set_state(new_state);
            Gst.State state = Gst.State.NULL;
            Gst.State pending;

            Gst.StateChangeReturn r;

            do {
                r = pipe.get_state(out state, out pending, 100);
                if (r == Gst.StateChangeReturn.FAILURE)
                    return false;
            } while (state != new_state);

            return true;
        }

        private void message_received(Gst.Message message) {
            if (message.type == Gst.MessageType.EOS) {
                if (change_pipeline_state(Gst.State.NULL)) {
                    reencoding = false;
                }
            }
        }

        private void reencode() {
            dest = Path.get_dirname(filename) + Path.DIR_SEPARATOR_S;
            if (album_mode && file_tags.track_number != -1)
                dest += "%02d - ".printf(file_tags.track_number);
            if (file_tags.artist != null)
                dest += file_tags.artist;
            dest += " - ";
            if (file_tags.title != null)
                dest += file_tags.title;
            dest += ".mp3";
            if (FileUtils.test(dest, FileTest.EXISTS)) {
                MessageDialog dialog;
                dialog = new MessageDialog(window,
                                           DialogFlags.DESTROY_WITH_PARENT,
                                           MessageType.QUESTION,
                                           ButtonsType.YES_NO,
                                           "The file '%s' already exists.\n" +
                                           "Rewrite it?", Path.get_basename(dest));
                int r = dialog.run();
                dialog.destroy();
                if (r != ResponseType.YES)
                    return;
            }
            start_pipeline();
            if (!change_pipeline_state(Gst.State.PLAYING)) {
                MessageDialog dialog;
                dialog = new MessageDialog(window,
                                           DialogFlags.DESTROY_WITH_PARENT,
                                           MessageType.INFO, ButtonsType.OK,
                                           "There was an error while\n" +
                                           "reencoding file '%s'.\n",
                                           Path.get_basename(filename));
                dialog.run();
                dialog.destroy();
                return;
            }
            create_progress_dialog();
            progress.show_all();
            Idle.add(upgrade_progressbar);
            int r = progress.run();
            progress.destroy();
            if (r == ResponseType.OK) {
                next_filename();
            }
        }

        private void update_tags() {
            file_tags.update();
            next_filename();
        }

        public void start() {
            window.show_all();
        }

        public static int main(string[] args) {
            DateTime dt = new DateTime.now_local();
            current_year = dt.get_year();

            Gtk.init(ref args);
            Gst.init(ref args);

            var files = new ArrayList<string>();

            for (int i = 1; i < args.length; i++) {
                if (FileUtils.test(args[i], FileTest.EXISTS))
                    files.add(args[i]);
                else
                    stderr.printf("The file '%s' does not exists. Ignoring.\n", args[i]);
            }

            var encoder = new Encoder(files);
            encoder.start();

            Gtk.main();

            return 0;
        }
    }
}
