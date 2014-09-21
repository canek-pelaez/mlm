/*
 * This file is part of mlm.
 *
 * Copyright 2013-2014 Canek Peláez Valdés
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

    public class Analyzer {

        private enum ReturnCode {
            OK               = 0,
            INVALID_ARGUMENT = 1,
            MISSING_FILES    = 2
        }

        private Id3Tag.Tag tag;
        private string filename;

        public Analyzer(string filename) {
            this.filename = filename;
        }

        private void analyze_text_encoding(Id3Tag.Field field) {
            string test_encoding = "";
            switch (field.gettextencoding()) {
            case Id3Tag.FieldTextEncoding.ISO_8859_1:
                test_encoding = "ISO-8859-1";
                break;
            case Id3Tag.FieldTextEncoding.UTF_16:
                test_encoding = "UTF-16";
                break;
            case Id3Tag.FieldTextEncoding.UTF_16BE:
                test_encoding = "UTF-16BE";
                break;
            case Id3Tag.FieldTextEncoding.UTF_8:
                test_encoding = "UTF-8";
                break;
            default:
                test_encoding = "UNKNOWN";
                break;
            }
            stdout.printf(Util.term_key_value("Textencoding", test_encoding));
        }

        private void analyze_stringlist(Id3Tag.Field field) {
            for (int i = 0; i < field.stringlist.length; i++) {
                string s = Id3Tag.UCS4.utf8duplicate(field.getstrings(i));
                stdout.printf("\t\t%s %s: \"%s\"\n",
                              Util.term_blue("String"),
                              Util.term_cyan("%d".printf(i)),
                              Util.term_yellow(s));
            }
        }

        private void analyze_picture_type(Id3Tag.Field field) {
            string ptype = "";
            switch (field.number_value) {
            case Id3Tag.PictureType.OTHER:
                ptype = "Other";
                break;
            case Id3Tag.PictureType.PNG32ICON:
                ptype = " 32x32 pixels 'file icon' (PNG only)";
                break;
            case Id3Tag.PictureType.OTHERICON:
                ptype = "Other file icon";
                break;
            case Id3Tag.PictureType.COVERFRONT:
                ptype = "Cover (front)";
                break;
            case Id3Tag.PictureType.COVERBACK:
                ptype = "Cover (back)";
                break;
            case Id3Tag.PictureType.LEAFLETPAGE:
                ptype = "Leaflet page";
                break;
            case Id3Tag.PictureType.MEDIA:
                ptype = "Media (e.g. lable side of CD)";
                break;
            case Id3Tag.PictureType.LEADARTIST:
                ptype = "Lead artist/lead performer/soloist";
                break;
            case Id3Tag.PictureType.ARTIST:
                ptype = "Artist/performer";
                break;
            case Id3Tag.PictureType.CONDUCTOR:
                ptype = "Conductor";
                break;
            case Id3Tag.PictureType.BAND:
                ptype = "Band/Orchestra";
                break;
            case Id3Tag.PictureType.COMPOSER:
                ptype = "Composer";
                break;
            case Id3Tag.PictureType.LYRICIST:
                ptype = "Lyricist/text writer";
                break;
            case Id3Tag.PictureType.REC_LOCATION:
                ptype = "Recording Location";
                break;
            case Id3Tag.PictureType.RECORDING:
                ptype = "During recording";
                break;
            case Id3Tag.PictureType.PERFORMANCE:
                ptype = "During performance";
                break;
            case Id3Tag.PictureType.VIDEO:
                ptype = "Movie/video screen capture";
                break;
            case Id3Tag.PictureType.FISH:
                ptype = "A bright coloured fish";
                break;
            case Id3Tag.PictureType.ILLUSTRATION:
                ptype = "Illustration";
                break;
            case Id3Tag.PictureType.ARTISTLOGO:
                ptype = "Band/artist logotype";
                break;
            case Id3Tag.PictureType.PUBLISHERLOGO:
                ptype = "Publisher/Studio logotype";
                break;
            default:
                ptype = "UNKNONW";
                break;
            }
            stdout.printf("\t%s: \"%s\"\n",
                          Util.term_blue("Picture type"),
                          Util.term_yellow(ptype));
        }

        private void analyze_field(Id3Tag.Frame frame,
                                   Id3Tag.Field field) {
            int v;
            string s;
            switch (field.type) {
            case Id3Tag.FieldType.TEXTENCODING:
                analyze_text_encoding(field);
                break;
            case Id3Tag.FieldType.LATIN1:
                stdout.printf("\t%s: %s\n",
                              Util.term_blue("Latin1"),
                              Util.term_yellow(field.getlatin1()));
                break;
            case Id3Tag.FieldType.LATIN1FULL:
                stdout.printf("\tLatin1 full\n");
                break;
            case Id3Tag.FieldType.LATIN1LIST:
                stdout.printf("\tLatin1 list\n");
                break;
            case Id3Tag.FieldType.STRING:
                s = Id3Tag.UCS4.utf8duplicate(field.getstring());
                stdout.printf("\t%s: \"%s\"\n",
                              Util.term_blue("String"),
                              Util.term_yellow(s));
                break;
            case Id3Tag.FieldType.STRINGFULL:
                s = Id3Tag.UCS4.utf8duplicate(field.getfullstring());
                stdout.printf("\t%s: \"%s\"\n",
                              Util.term_blue("String full"),
                              Util.term_yellow(s));
                break;
            case Id3Tag.FieldType.STRINGLIST:
                stdout.printf("\t%s\n", Util.term_blue("String list"));
                analyze_stringlist(field);
                break;
            case Id3Tag.FieldType.LANGUAGE:
                stdout.printf("\t%s: %s\n",
                              Util.term_blue("Languaje"),
                              Util.term_yellow((string)field.immediate_value));
                break;
            case Id3Tag.FieldType.FRAMEID:
                stdout.printf("\tFrame id\n");
                break;
            case Id3Tag.FieldType.DATE:
                stdout.printf("\tDate\n");
                break;
            case Id3Tag.FieldType.INT8:
                v = (int)field.number_value;
                if (frame.id == FrameId.PICTURE) {
                    analyze_picture_type(field);
                } else if (frame.id == FrameId.POPULARIMETER) {
                    double r = v / 2.55;
                    stdout.printf("\t%s: %s\n",
                                  Util.term_blue("Rating"),
                                  Util.term_yellow("%g%%".printf(r)));
                } else {
                    stdout.printf("\t%s: %s\n",
                                  Util.term_blue("UNKNOWN int8"),
                                  Util.term_yellow("%d".printf(v)));
                }
                break;
            case Id3Tag.FieldType.INT16:
                stdout.printf("\tInt16\n");
                break;
            case Id3Tag.FieldType.INT24:
                stdout.printf("\tInt24\n");
                break;
            case Id3Tag.FieldType.INT32:
                stdout.printf("\tInt32\n");
                break;
            case Id3Tag.FieldType.INT32PLUS:
                v = (int)field.number_value;
                if (frame.id == FrameId.POPULARIMETER) {
                    stdout.printf("\t%s: %s\n",
                                  Util.term_blue("Counter"),
                                  Util.term_yellow("%d".printf(v)));
                } else {
                    stdout.printf("\t%s: %s\n",
                                  Util.term_blue("UNKNOWN int32 plus"),
                                  Util.term_yellow("%d".printf(v)));
                }
                break;
            case Id3Tag.FieldType.BINARYDATA:
                stdout.printf("\t%s: %s bytes\n",
                              Util.term_blue("Binary data"),
                              Util.term_yellow("%d".printf(field.binary_data.length)));
                break;
            default:
                break;
            }
        }

        private void analyze_frame(Id3Tag.Frame frame) {
            stdout.printf("%s %s: (%s)\n",
                          Util.term_blue("Frame"),
                          Util.term_yellow(frame.id),
                          Util.term_cyan(frame.description));
            for (int i = 0; i < frame.fields.length; i++) {
                analyze_field(frame, frame.field(i));
            }
        }

        public void analyze() {
            if (!FileUtils.test(filename, FileTest.EXISTS)) {
                stderr.printf("%s: No such file.\n", filename);
                return;
            }
            Id3Tag.File file = new Id3Tag.File(filename, Id3Tag.FileMode.READONLY);
            if (file == null) {
                stderr.printf("%s: Could not link to file.\n", filename);
                return;
            }
            tag = file.tag();
            if (tag == null) {
                stderr.printf("%s: Could not extract tags from file.\n", filename);
                return;
            }
            if (tag.frames.length == 0)
                stderr.printf("%s: File has no frames.\n", filename);
            for (int i = 0; i < tag.frames.length; i++) {
                analyze_frame(tag.frames[i]);
            }
            file.close();
        }

        public static int error(string message,
                                int    return_code,
                                string command) {
            stderr.printf("error: %s\n", message);
            stderr.printf("Run ‘%s --help’ for a list of options.\n".printf(command));
            return return_code;
        }

        public static int main(string[] args) {
            try {
                var opt_context = new OptionContext("FILE... - Analyze Id3v2.4.0 tags");
                opt_context.set_help_enabled(true);
                opt_context.parse(ref args);
            } catch (GLib.OptionError e) {
                return error(e.message, ReturnCode.INVALID_ARGUMENT, args[0]);
            }

            if (args.length < 2)
                return error("Missing MP3 file(s)", ReturnCode.MISSING_FILES, args[0]);

            for (int i = 1; i < args.length; i++) {
                Analyzer a = new Analyzer(args[i]);
                a.analyze();
            }

            return ReturnCode.OK;
        }
    }
}
