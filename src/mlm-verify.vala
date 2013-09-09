using Id3Tag;

namespace MLM {

    public class Verify {

        private string filename;
        private string report;
        private bool anomalies;
        private int current_year;

        public Verify(string filename) {
            this.filename = filename;
            report = "";
            anomalies = false;
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
                    field.gettextencoding() != FieldTextEncoding.UTF_8)
                    add_to_report("\tThe %s encoding is not UTF-8.\n".printf(fid));
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

        }

        private void verify_comment_frame(Frame frame) {
            for (int i = 0; i < frame.fields.length; i++) {
                Field field = frame.field(i);
                if (field.type == FieldType.TEXTENCODING &&
                    field.gettextencoding() != FieldTextEncoding.UTF_8)
                    add_to_report("\tThe comment encoding is not UTF-8.\n");
                if (field.type == FieldType.LANGUAGE &&
                    (string)field.immediate_value != "eng")
                    add_to_report("\tThe comment language is not \"eng\".\n");
                if (field.type == FieldType.STRING &&
                    (string)field.getstring() != "")
                    add_to_report("\tThe small comment is not empty.\n");
            }
            if (frame.get_comment_text() == "")
                add_to_report("\tThe comment is empty.\n");
        }

        private void verify_picture_frame(Frame frame) {

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
                    int t = verify_track_frame(frame);
                    track = "%02d".printf(t);
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
            if (fcp > 1) {
                add_to_report("\tFile has more than one front cover picture.\n");
            }
            if (ap > 1) {
                add_to_report("\tFile has more than one artist picture.\n");
            }
            if (comments > 1) {
                add_to_report("\tFile has more than one comment.\n");
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
            for (int i = 1; i < args.length; i++) {
                Verify v = new Verify(args[i]);
                v.verify();
            }

            return 0;
        }
    }
}
