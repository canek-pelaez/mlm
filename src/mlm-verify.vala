using Id3Tag;

namespace MLM {

    public class Verify {

        private string filename;
        private string report;
        private bool anomalies;
        private bool fixit;
        private int current_year;

        public Verify(string filename, bool fixit = false) {
            this.filename = filename;
            report = "";
            anomalies = false;
            this.fixit = fixit;
            DateTime dt = new DateTime.now_local();
            current_year = dt.get_year();
        }

        private void add_to_report(string s) {
            anomalies = true;
            report += s;
        }

        private void verify_frame_textencoding(Frame frame, string fid) {
            for (int i = 0; i < frame.fields.length; i++) {
                Field field = frame.field(i);
                if (field.type == FieldType.TEXTENCODING &&
                    field.gettextencoding() != FieldTextEncoding.UTF_8) {
                    add_to_report("\tThe %s encoding is not UTF-8.\n".printf(fid));
                    if (fixit) {
                        field.settextencoding(FieldTextEncoding.UTF_8);
                        add_to_report("\t\t...fixed.\n");
                    }
                }
            }
        }

        private void verify_text_frame(Frame  frame,
                                       string fid,
                                       bool   check_empty) {
            verify_frame_textencoding(frame, fid);
            if (check_empty && frame.get_text() == "")
                add_to_report("\nThe %s frame is empty.\n".printf(fid));
        }

        private void verify_year_frame(Frame frame) {
            verify_frame_textencoding(frame, "year");
            int year = int.parse(frame.get_text());
            if (year < 1900 || year > current_year)
                add_to_report("\tThe year %d is out of range.\n".printf(year));
        }

        private void verify_disc_frame(Frame frame) {
            verify_frame_textencoding(frame, "disc");
            int disc = int.parse(frame.get_text());
            if (disc < 1 || disc > 99)
                add_to_report("\tThe disc %d is out of range.\n".printf(disc));
        }

        private void verify_genre_frame(Frame frame) {
            verify_frame_textencoding(frame, "genre");
            string g = frame.get_text();
            bool number = true;
            int n = -1;
            for (int i = 0; i < g.data.length; i++)
                if (g.data[i] < (int)'0' || g.data[i] > (int)'9')
                    number = false;
            Genre[] genres = Genre.all();
            if (!number) {
                for (int i = 0; i < genres.length; i++)
                    if (g == genres[i].to_string())
                        n = i;
                if (n != -1) {
                    add_to_report("\tThe genre %s is not in numerical format.\n".printf(g));
                    if (fixit) {
                        frame.set_text("%d".printf(n));
                        add_to_report("\t\t...fixed.\n");
                    }
                } else {
                    add_to_report("\tThe genre %s is not valid.\n".printf(g));
                }
            } else {
                n = int.parse(g);
                if (n < 0 || n >= genres.length)
                    add_to_report("\tThe genre %s is invalid.\n".printf(g));
            }
        }

        private void verify_comment_frame(Frame frame) {
            for (int i = 0; i < frame.fields.length; i++) {
                Field field = frame.field(i);
                if (field.type == FieldType.TEXTENCODING &&
                    field.gettextencoding() != FieldTextEncoding.UTF_8) {
                    add_to_report("\tThe comment encoding is not UTF-8.\n");
                    if (fixit) {
                        field.settextencoding(FieldTextEncoding.UTF_8);
                        add_to_report("\t\t...fixed.\n");
                    }
                }
                if (field.type == FieldType.LANGUAGE &&
                    (string)field.immediate_value != "eng") {
                    add_to_report("\tThe comment language is not 'eng'.\n");
                    if (fixit) {
                        field.setlanguage("eng");
                        add_to_report("\t\t...fixed.\n");
                    }
                }
                if (field.type == FieldType.STRING &&
                    (string)field.getstring() != "") {
                    add_to_report("\tThe small comment is not empty.\n");
                    if (fixit) {
                        field.setstring("");
                        add_to_report("\t\t...fixed.\n");
                    }
                }
            }
            if (frame.get_comment_text() == "")
                add_to_report("\tThe comment is empty.\n");
        }

        private void verify_picture_frame(Frame frame) {
            for (int i = 0; i < frame.fields.length; i++) {
                Field field = frame.field(i);
                if (field.type == FieldType.TEXTENCODING &&
                    field.gettextencoding() != FieldTextEncoding.UTF_8)
                    add_to_report("\tThe picture text encoding is not UTF-8.\n");
                if (field.type == FieldType.LATIN1 &&
                    (string)field.getlatin1() != "image/jpeg")
                    add_to_report("\tThe picture mime type is not 'image/jpeg'.\n");
                if (field.type == FieldType.INT8 &&
                    field.getint() != PictureType.COVERFRONT &&
                    field.getint() != PictureType.ARTIST)
                    add_to_report("\tThe picture type is neither cover front nor artist.\n");
            }
            string desc = frame.get_picture_description();
            if (desc == "") {
                add_to_report("\tThe picture description is empty.\n");
            }
            if (desc.has_prefix("(No Disc)") && desc == "(No Disc) cover") {
                add_to_report("\tThe picture description '%s' is redundant.\n".printf(desc));
                if (fixit) {
                    frame.set_picture_description("(No Disc)");
                    add_to_report("\t\t...fixed.\n");
                }
            }
        }

        private int verify_track_frame(Frame frame) {
            verify_frame_textencoding(frame, "track");
            string t = frame.get_text();
            int tn, tc;
            if (t.index_of("/") == -1) {
                add_to_report("\tTrack count missing.\n");
                tn = int.parse(t);
                if (tn < 1 || tn > 99)
                    add_to_report("\tThe track number %d is out of range.\n".printf(tn));
            } else {
                string[] tt = t.split("/");
                tn = int.parse(tt[0]);
                tc = int.parse(tt[1]);
                if (tn < 1 || tn > 99)
                    add_to_report("\tThe track number %d is out of range.\n".printf(tn));
                if (tc < 1 || tc > 99)
                    add_to_report("\tThe track count %d is out of range.\n".printf(tn));
                if (tc < tn)
                    add_to_report("\tThe track count %d is less than the track number.\n".printf(tn));
            }
            return tn;
        }

        public void verify() {
            if (!FileUtils.test(filename, FileTest.EXISTS)) {
                stderr.printf("%s: No such file.\n", filename);
                return;
            }
            File file = new File(filename, FileMode.READWRITE);
            if (file == null) {
                stderr.printf("%s: Could not link to file.\n", filename);
                return;
            }
            Tag tag = file.tag();
            if (tag == null) {
                stderr.printf("%s: Could not extract tags from file.\n", filename);
                return;
            }
            report = "%s:\n".printf(filename);
            if (tag.frames.length == 0)
                add_to_report("\tFile has no frames.\n");
            int fcp = 0;
            int ap = 0;
            int comments = 0;
            int tn = -1;
            string track = "";
            string artist = "";
            string title = "";
            for (int i = 0; i < tag.frames.length; i++) {
                Frame frame = tag.frames[i];
                if (frame.id == FrameId.ARTIST) {
                    verify_text_frame(frame, "artist", true);
                    artist = frame.get_text();
                } else if (frame.id == FrameId.TITLE) {
                    verify_text_frame(frame, "title", true);
                    title = frame.get_text();
                } else if (frame.id == FrameId.ALBUM) {
                    verify_text_frame(frame, "album", true);
                } else if (frame.id == FrameId.COMPOSER) {
                    verify_text_frame(frame, "composer", false);
                } else if (frame.id == FrameId.ORIGINAL) {
                    verify_text_frame(frame, "original artist", false);
                } else if (frame.id == FrameId.YEAR) {
                    verify_year_frame(frame);
                } else if (frame.id == FrameId.DISC) {
                    verify_disc_frame(frame);
                } else if (frame.id == FrameId.TRACK) {
                    tn = verify_track_frame(frame);
                    track = "%02d".printf(tn);
                } else if (frame.id == FrameId.GENRE) {
                    verify_genre_frame(frame);
                } else if (frame.id == FrameId.COMMENT) {
                    verify_comment_frame(frame);
                    comments++;
                } else if (frame.id == FrameId.COMMENT) {
                    verify_comment_frame(frame);
                } else if (frame.id == FrameId.PICTURE) {
                    verify_picture_frame(frame);
                    if (frame.get_picture_type() == PictureType.COVERFRONT)
                        fcp++;
                    if (frame.get_picture_type() == PictureType.ARTIST)
                        ap++;
                }
            }
            if (tn == -1)
                add_to_report("\tThe file has no track defined.\n");
            if (artist == "")
                add_to_report("\tThe file has no artist defined.\n");
            if (title == "")
                add_to_report("\tThe file has no title defined.\n");
            if (fcp > 1)
                add_to_report("\tFile has more than one front cover picture.\n");
            if (ap > 1)
                add_to_report("\tFile has more than one artist picture.\n");
            if (comments > 1)
                add_to_report("\tFile has more than one comment.\n");
            if (anomalies && fixit) {
                tag.options(TagOption.COMPRESSION, 0);
                file.update();
            }
            file.close();
            string bn = Path.get_basename(filename);
            if (bn != track + " - " + artist + " - " + title + ".mp3" &&
                bn != artist + " - " + title + ".mp3") {
                add_to_report("\tFile it's not called '%s' nor '%s'.\n".printf
                              (track + " - " + artist + " - " + title + ".mp3",
                               artist + " - " + title + ".mp3"));
            }
            if (anomalies)
                stdout.printf(report);
        }

        public static int main(string[] args) {
            bool fixit = false;
            for (int i = 1; i < args.length; i++) {
                if (args[i] == "--fix") {
                    fixit = true;
                    continue;
                }
                Verify v = new Verify(args[i], fixit);
                v.verify();
            }

            return 0;
        }
    }
}
