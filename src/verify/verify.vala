/*
 * This file is part of mlm.
 *
 * Copyright © 2013-2018 Canek Peláez Valdés
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

    public class Verifier {

        private enum ExitCode {
            OK,
            INVALID_ARGUMENT,
            NO_SUCH_FILE;
        }

        private static bool fixit;
        private static bool missing_pictures;
        private static bool small_pictures;

        private const GLib.OptionEntry[] options = {
            { "fixit", 'f', 0, GLib.OptionArg.NONE, ref fixit,
              "Automatically fix what is fixable", null },
            { "missing-pictures", 'm', 0, GLib.OptionArg.NONE,
              ref missing_pictures, "Warn about missing pictures", null },
            { "small-pictures", 's', 0, GLib.OptionArg.NONE,
              ref small_pictures, "Warn about small pictures", null },
            { null }
        };

        private Id3Tag.Tag tag;
        private string filename;
        private string report;
        private bool anomalies;
        private int current_year;

        public Verifier(string filename) {
            this.filename = filename;
            report = "";
            anomalies = false;

            var dt = new DateTime.now_local();
            current_year = dt.get_year();
        }

        [PrintfFormat]
        private void add_to_report(string format, ...) {
            anomalies = true;
            var list = va_list();
            string s = format.vprintf(list);
            report += Util.color(s, Color.RED);
        }

        private string to_title(string str) {
            var t = "";
            bool up = true;
            unichar uc;
            int i = 0;
            while (str.get_next_char(ref i, out uc)) {
                char[] u = new char[7];
                if (uc.isalpha()) {
                    if (up) {
                        uc = uc.toupper();
                        up = false;
                    }
                } else {
                    uc.to_utf8((string)u);
                    if (!uc.isdigit() && ((string)u) != "'")
                        up = true;
                }
                uc.to_utf8((string)u);
                if ((string)u == " ")
                    up = true;
                t += (string)u;
            }
            return t;
        }

        private void verify_frame_textencoding(Id3Tag.Frame             frame,
                                               string                   fid,
                                               Id3Tag.FieldTextEncoding te =
                                               Id3Tag.FieldTextEncoding.UTF_8) {
            var tedesc = "UTF-8";
            if (te == Id3Tag.FieldTextEncoding.ISO_8859_1)
                tedesc = "ISO-8859-1";
            for (int i = 0; i < frame.fields.length; i++) {
                var field = frame.field(i);
                if (field.type == Id3Tag.FieldType.TEXTENCODING &&
                    field.gettextencoding() != te) {
                    add_to_report("\tThe %s encoding is not %s.\n",
                                  fid, tedesc);
                    if (fixit) {
                        field.settextencoding(te);
                        add_to_report("\t\t...fixed.\n");
                    }
                }
            }
        }

        private void verify_text_frame(Id3Tag.Frame frame,
                                       string       fid,
                                       bool         check_empty) {
            verify_frame_textencoding(frame, fid);
            if (check_empty && frame.get_text() == "")
                add_to_report("\nThe %s frame is empty.\n", fid);
        }

        private void verify_year_frame(Id3Tag.Frame frame) {
            verify_frame_textencoding(frame, "year");
            int year = int.parse(frame.get_text());
            if (year < 1900 || year > current_year)
                add_to_report("\tThe year %d is out of range.\n", year);
        }

        private int verify_disc_frame(Id3Tag.Frame frame) {
            verify_frame_textencoding(frame, "disc");
            int disc = int.parse(frame.get_text());
            if (disc < 1 || disc > 99)
                add_to_report("\tThe disc %d is out of range.\n", disc);
            return disc;
        }

        private void verify_genre_frame(Id3Tag.Frame frame) {
            verify_frame_textencoding(frame, "genre");
            var g = frame.get_text();
            var number = true;
            int n = -1;
            for (int i = 0; i < g.data.length; i++)
                if (g.data[i] < (int)'0' || g.data[i] > (int)'9')
                    number = false;
            var genres = Genre.all();
            if (!number) {
                for (int i = 0; i < genres.length; i++)
                    if (g == genres[i].to_string())
                        n = i;
                if (n != -1) {
                    add_to_report("\tThe genre %s is not in numerical " +
                                  "format.\n", g);
                    if (fixit) {
                        frame.set_text("%d".printf(n));
                        add_to_report("\t\t...fixed.\n");
                    }
                } else {
                    add_to_report("\tThe genre %s is not valid.\n", g);
                }
            } else {
                n = int.parse(g);
                if (n < 0 || n >= genres.length)
                    add_to_report("\tThe genre %s is invalid.\n", g);
            }
        }

        private void verify_comment_frame(Id3Tag.Frame frame) {
            for (int i = 0; i < frame.fields.length; i++) {
                var field = frame.field(i);
                if (field.type == Id3Tag.FieldType.TEXTENCODING &&
                    field.gettextencoding() != Id3Tag.FieldTextEncoding.UTF_8) {
                    add_to_report("\tThe comment encoding is not UTF-8.\n");
                    if (fixit) {
                        field.settextencoding(Id3Tag.FieldTextEncoding.UTF_8);
                        add_to_report("\t\t...fixed.\n");
                    }
                }
                if (field.type == Id3Tag.FieldType.LANGUAGE &&
                    (string)field.immediate_value != "eng") {
                    add_to_report("\tThe comment language is not 'eng'.\n");
                    if (fixit) {
                        field.setlanguage("eng");
                        add_to_report("\t\t...fixed.\n");
                    }
                }
                if (field.type == Id3Tag.FieldType.STRING &&
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

        private void verify_picture_frame(Id3Tag.Frame frame) {
            bool detach = false;
            var pt = Id3Tag.PictureType.OTHER;
            for (int i = 0; i < frame.fields.length; i++) {
                var field = frame.field(i);
                if (field.type == Id3Tag.FieldType.TEXTENCODING &&
                    field.gettextencoding() != Id3Tag.FieldTextEncoding.UTF_8)
                    add_to_report("\tThe picture text encoding is not " +
                                  "UTF-8.\n");
                if (field.type == Id3Tag.FieldType.LATIN1 &&
                    (string)field.getlatin1() != "image/jpeg")
                    add_to_report("\tThe picture mime type is not " +
                                  "'image/jpeg'.\n");
                if (field.type == Id3Tag.FieldType.INT8) {
                    pt = (Id3Tag.PictureType)field.getint();
                    if (pt != Id3Tag.PictureType.COVERFRONT &&
                        pt != Id3Tag.PictureType.ARTIST) {
                        add_to_report("\tThe picture type is neither cover " +
                                      "front nor artist.\n");
                        if (fixit)
                            detach = true;
                    }
                }
            }
            if (detach) {
                tag.detachframe(frame);
                add_to_report("\t\t...fixed.\n");
                return;
            }
            if (small_pictures) {
                uint8[] data = frame.get_picture(pt);
                string ptype = "front cover";
                if (pt == Id3Tag.PictureType.ARTIST)
                    ptype = "artist";
                var mis = new GLib.MemoryInputStream.from_data(data, null);
                Gdk.Pixbuf pixbuf = null;
                try {
                    pixbuf = new Gdk.Pixbuf.from_stream(mis);
                } catch (Error e) {
                    stderr.printf("Could not set pixbuf from data.\n");
                }
                if (pixbuf != null) {
                    int max = int.max(pixbuf.width, pixbuf.height);
                    if (max < 500)
                        add_to_report("\tThe %s longest side is " +
                                      "less than 500 pixels (%d).\n",
                                      ptype, max);
                }
            }
            var desc = frame.get_picture_description();
            if (desc == "") {
                add_to_report("\tThe picture description is empty.\n");
            }
            if (desc.has_prefix("(No Disc)") && desc == "(No Disc) cover") {
                add_to_report("\tThe picture description '%s' is redundant.\n",
                              desc);
                if (fixit) {
                    frame.set_picture_description("(No Disc)");
                    add_to_report("\t\t...fixed.\n");
                }
            }
            if (desc == "(No Disc)")
                return;
            var album_frame = tag.search_frame(FrameId.ALBUM);
            if (album_frame == null)
                return;
            var album = album_frame.get_text();
            if (pt == Id3Tag.PictureType.COVERFRONT && desc !=
                album + " cover") {
                add_to_report("\tThe front cover description is " +
                              "not correct.\n");
                if (fixit) {
                    frame.set_picture_description(album + " cover");
                    add_to_report("\t\t...fixed.\n");
                }
            }
        }

        private int verify_track_frame(Id3Tag.Frame frame) {
            verify_frame_textencoding(frame, "track");
            var t = frame.get_text();
            int tn, tc;
            if (t.index_of("/") == -1) {
                add_to_report("\tTrack count missing.\n");
                tn = int.parse(t);
                if (tn < 1 || tn > 99)
                    add_to_report("\tThe track number %d is out of range.\n",
                                  tn);
            } else {
                var tt = t.split("/");
                tn = int.parse(tt[0]);
                tc = int.parse(tt[1]);
                if (tn < 1 || tn > 99)
                    add_to_report("\tThe track number %d is out of range.\n",
                                  tn);
                if (tc < 1 || tc > 99)
                    add_to_report("\tThe track count %d is out of range.\n",
                                  tc);
                if (tc < tn)
                    add_to_report("\tThe track count %d is less than the " +
                                  "track number.\n", tn);
            }
            return tn;
        }

        public void verify() {
            if (!FileUtils.test(filename, FileTest.EXISTS)) {
                stderr.printf("%s: No such file.\n", filename);
                return;
            }
            var file = new Id3Tag.File(filename, Id3Tag.FileMode.READWRITE);
            if (file == null) {
                stderr.printf("%s: Could not link to file.\n", filename);
                return;
            }
            tag = file.tag();
            if (tag == null) {
                stderr.printf("%s: Could not extract tags from file.\n",
                              filename);
                return;
            }
            report = "%s:\n".printf(Util.color(filename, Color.CYAN));
            if (tag.frames.length == 0)
                add_to_report("\tFile has no frames.\n");
            int fcp = 0;
            int ap = 0;
            int comments = 0;
            int tn = -1;
            int d = -1;
            string artist = "";
            string title = "";
            string album = "";
            string track = "";
            string disc = "";
            var invalid = new Gee.ArrayList<Id3Tag.Frame>();
            for (int i = 0; i < tag.frames.length; i++) {
                var frame = tag.frames[i];
                if (frame.id == FrameId.ARTIST) {
                    verify_text_frame(frame, "artist", true);
                    artist = frame.get_text();
                } else if (frame.id == FrameId.TITLE) {
                    verify_text_frame(frame, "title", true);
                    title = frame.get_text();
                    var tt = to_title(title);
                    if (tt != title) {
                        add_to_report("\tThe title %s is not in title " +
                                      "format.\n", title);
                        if (fixit) {
                            title = tt;
                            frame.set_text(title);
                            add_to_report("\t\t...fixed.\n");
                        }
                    }
                } else if (frame.id == FrameId.ALBUM) {
                    verify_text_frame(frame, "album", true);
                    album = frame.get_text();
                } else if (frame.id == FrameId.COMPOSER) {
                    verify_text_frame(frame, "composer", false);
                } else if (frame.id == FrameId.ORIGINAL) {
                    verify_text_frame(frame, "original artist", false);
                } else if (frame.id == FrameId.YEAR) {
                    verify_year_frame(frame);
                } else if (frame.id == FrameId.DISC) {
                    d = verify_disc_frame(frame);
                    disc = "Disc %d".printf(d);
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
                    if (frame.get_picture_type() == Id3Tag.PictureType.COVERFRONT)
                        fcp++;
                    if (frame.get_picture_type() == Id3Tag.PictureType.ARTIST)
                        ap++;
                } else {
                    invalid.add(frame);
                }
            }
            foreach (var frame in invalid) {
                add_to_report("\tThe frame '%s' is invalid.\n", frame.id);
                if (fixit) {
                    tag.detachframe(frame);
                    add_to_report("\t\t...fixed.\n");
                }
            }
            if (tn == -1 && album != "(No Disc)")
                add_to_report("\tThe file has no track defined.\n");
            if (artist == "")
                add_to_report("\tThe file has no artist defined.\n");
            if (title == "")
                add_to_report("\tThe file has no title defined.\n");
            if (fcp > 1)
                add_to_report("\tFile has more than one front cover " +
                              "picture.\n");
            if (ap > 1)
                add_to_report("\tFile has more than one artist picture.\n");
            if (missing_pictures && fcp < 1)
                add_to_report("\tFile has no front cover picture.\n");
            if (missing_pictures && ap < 1)
                add_to_report("\tFile has no artist picture.\n");
            if (comments > 1)
                add_to_report("\tFile has more than one comment.\n");
            if (anomalies && fixit) {
                tag.options(Id3Tag.TagOption.COMPRESSION, 0);
                file.update();
            }
            file.close();
            string dn = Path.get_dirname(filename);
            string bn = Path.get_basename(filename);
            artist = artist.replace("/", "_");
            title = title.replace("/", "_");
            string cn1 = track + " - " + artist + " - " + title + ".mp3";
            string cn2 = artist + " - " + title + ".mp3";
            string cn3 = disc + " - " + track + " - " + artist + " - " + title + ".mp3";
            if (bn != cn1 && bn != cn2 && bn != cn3) {
                add_to_report("\tFile it's not called '%s' nor '%s' nor '%s'.\n", cn1, cn2, cn3);
                if (fixit) {
                    if (bn.data[0] >= (int)'0' && bn.data[0] <= (int)'9')
                        FileUtils.rename(filename, dn +
                                         Path.DIR_SEPARATOR_S + cn1);
                    else if (bn.has_prefix("Disc"))
                        FileUtils.rename(filename, dn +
                                         Path.DIR_SEPARATOR_S + cn3);
                    else
                        FileUtils.rename(filename, dn +
                                         Path.DIR_SEPARATOR_S + cn2);
                    add_to_report("\t\t...fixed.\n");
                }
            }
            if (anomalies)
                stdout.printf(report);
        }

        private const string CONTEXT =
            "[FILENAME...] - Verify MP3 files";

        public static int main(string[] args) {
            try {
                var opt = new GLib.OptionContext(CONTEXT);
                opt.set_help_enabled(true);
                opt.add_main_entries(options, null);
                opt.parse(ref args);
            } catch (GLib.OptionError e) {
                Util.error(true, ExitCode.INVALID_ARGUMENT, args[0],
                           e.message);
            }

            if (args.length < 2)
                Util.error(true, ExitCode.NO_SUCH_FILE, args[0],
                           "Missing MP3 file(s)");

            for (int i = 1; i < args.length; i++) {
                Verifier v = new Verifier(args[i]);
                v.verify();
            }

            return ExitCode.OK;
        }
    }
}
