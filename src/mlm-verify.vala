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

using Id3Tag;

namespace MLM {

    public class Verify {

        private Tag tag;
        private string filename;
        private string report;
        private bool anomalies;
        private bool fixit;
        private bool missing_pictures;
        private bool small_pictures;
        private int current_year;

        public Verify(string filename, bool fixit, bool missing_pictures, bool small_pictures) {
            this.filename = filename;
            report = "";
            anomalies = false;
            this.fixit = fixit;
            this.missing_pictures = missing_pictures;
            this.small_pictures = small_pictures;
            DateTime dt = new DateTime.now_local();
            current_year = dt.get_year();
        }

        private void add_to_report(string s) {
            anomalies = true;
            report += s;
        }

        private string to_title(string str) {
            string t = "";
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

        private int verify_disc_frame(Frame frame) {
            verify_frame_textencoding(frame, "disc");
            int disc = int.parse(frame.get_text());
            if (disc < 1 || disc > 99)
                add_to_report("\tThe disc %d is out of range.\n".printf(disc));
            return disc;
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
            bool detach = false;
            PictureType pt = PictureType.OTHER;
            for (int i = 0; i < frame.fields.length; i++) {
                Field field = frame.field(i);
                if (field.type == FieldType.TEXTENCODING &&
                    field.gettextencoding() != FieldTextEncoding.UTF_8)
                    add_to_report("\tThe picture text encoding is not UTF-8.\n");
                if (field.type == FieldType.LATIN1 &&
                    (string)field.getlatin1() != "image/jpeg")
                    add_to_report("\tThe picture mime type is not 'image/jpeg'.\n");
                if (field.type == FieldType.INT8) {
                    pt = (PictureType)field.getint();
                    if (pt != PictureType.COVERFRONT && pt != PictureType.ARTIST) {
                        add_to_report("\tThe picture type is neither cover front nor artist.\n");
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
            if (desc == "(No Disc)")
                return;
            Frame album_frame = tag.search_frame(FrameId.ALBUM);
            if (album_frame == null)
                return;
            string album = album_frame.get_text();
            if (pt == PictureType.COVERFRONT && desc != album + " cover") {
                add_to_report("\tThe front cover description is not correct.\n");
                if (fixit) {
                    frame.set_picture_description(album + " cover");
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
                    add_to_report("\tThe track count %d is out of range.\n".printf(tc));
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
            tag = file.tag();
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
            int d = -1;
            string artist = "";
            string title = "";
            string album = "";
            string track = "";
            string disc = "";
            var invalid = new Gee.ArrayList<Frame>();
            for (int i = 0; i < tag.frames.length; i++) {
                Frame frame = tag.frames[i];
                if (frame.id == FrameId.ARTIST) {
                    verify_text_frame(frame, "artist", true);
                    artist = frame.get_text();
                } else if (frame.id == FrameId.TITLE) {
                    verify_text_frame(frame, "title", true);
                    title = frame.get_text();
                    string tt = to_title(title);
                    if (tt != title) {
                        add_to_report("\tThe title %s is not in title format.\n".printf(title));
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
                    if (frame.get_picture_type() == PictureType.COVERFRONT)
                        fcp++;
                    if (frame.get_picture_type() == PictureType.ARTIST)
                        ap++;
                } else {
                    invalid.add(frame);
                }
            }
            foreach (var frame in invalid) {
                add_to_report("\tThe frame '%s' is invalid.\n".printf(frame.id));
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
                add_to_report("\tFile has more than one front cover picture.\n");
            if (ap > 1)
                add_to_report("\tFile has more than one artist picture.\n");
            if (missing_pictures && fcp < 1)
                add_to_report("\tFile has no front cover picture.\n");
            if (missing_pictures && ap < 1)
                add_to_report("\tFile has no artist picture.\n");
            if (comments > 1)
                add_to_report("\tFile has more than one comment.\n");
            if (anomalies && fixit) {
                tag.options(TagOption.COMPRESSION, 0);
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
                add_to_report("\tFile it's not called '%s' nor '%s' nor '%s'.\n".printf(cn1, cn2, cn3));
                if (fixit) {
                    if (bn.data[0] >= (int)'0' && bn.data[0] <= (int)'9')
                        FileUtils.rename(filename, dn + Path.DIR_SEPARATOR_S + cn1);
                    else if (bn.has_prefix("Disc"))
                        FileUtils.rename(filename, dn + Path.DIR_SEPARATOR_S + cn3);
                    else
                        FileUtils.rename(filename, dn + Path.DIR_SEPARATOR_S + cn2);
                    add_to_report("\t\t...fixed.\n");
                }
            }
            if (anomalies)
                stdout.printf(report);
        }

        public static int main(string[] args) {
            bool fixit = false;
            bool missing_pictures = false;
            bool small_pictures = false;
            for (int i = 1; i < args.length; i++) {
                if (args[i] == "--fix") {
                    fixit = true;
                    continue;
                } else if (args[i] == "--missing-pictures") {
                    missing_pictures = true;
                    continue;
                } else if (args[i] == "--small-pictures") {
                    small_pictures = true;
                    continue;
                }
                Verify v = new Verify(args[i], fixit, missing_pictures, small_pictures);
                v.verify();
            }

            return 0;
        }
    }
}
