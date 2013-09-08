using Gee;
using Gtk;

namespace MLM {

    public class Encoder {

        private static int current_year;
        private static const string UI = "data/mlm-encoder.ui";

        private ArrayList<string> files;
        private Window window;
        private bool album_mode;

        public Encoder(ArrayList<string> files) {
            this.files = files;
            var builder = new Builder();
            try {
                builder.add_from_file(UI);
            } catch (Error e) {
                error("Could not open UI file '%s'.", UI);
            }
            window = builder.get_object("window") as Window;
            window.window_position = WindowPosition.CENTER_ALWAYS;
            window.destroy.connect(Gtk.main_quit);

            if (files.size == 0) {
                window.set_sensitive(false);
                return;
            }

            /* Stupid GtkBuilder. */
            ComboBox combo = builder.get_object("genre_comboboxtext") as ComboBox;
            EntryCompletion completion = new EntryCompletion();
            completion.set_model(combo.get_model());
            completion.inline_completion = true;
            completion.set_text_column(0);
            Entry entry = builder.get_object("comboboxtext_entry") as Entry;
            entry.set_completion(completion);

            Button button = builder.get_object("cover_open_button") as Button;
            button.clicked.connect(() => { select_cover_picture(); });
            button = builder.get_object("cover_clear_button") as Button;
            button.clicked.connect(() => { clear_cover_picture(); });
            button = builder.get_object("artist_open_button") as Button;
            button.clicked.connect(() => { select_artist_picture(); });
            button = builder.get_object("artist_clear_button") as Button;
            button.clicked.connect(() => { clear_artist_picture(); });
            button = builder.get_object("reencode_button") as Button;
            button.clicked.connect(() => { reencode(); });
            button = builder.get_object("update_tags_button") as Button;
            button.clicked.connect(() => { update_tags(); });
            /*CheckButton check = builder.get_object("update_tags_button") as CheckButton;
              check.toggled.connect((c) => { album_mode = c.get_mode(); });*/
        }

        private void select_cover_picture() {
        }

        private void clear_cover_picture() {
        }

        private void select_artist_picture() {
        }

        private void clear_artist_picture() {
        }

        private void reencode() {
        }

        private void update_tags() {
        }

        public void start() {
            window.show_all();
        }

        public static int main(string[] args) {
            DateTime dt = new DateTime.now_local();
            current_year = dt.get_year();

            Gtk.init(ref args);

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
