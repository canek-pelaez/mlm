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

extern void exit(int exit_code);

namespace MLM {

    public class Analyzer {

        private Tag tag;
        private string filename;

        public Analyzer(string filename) {
            this.filename = filename;
        }

        private void analyze_text_encoding(Field field) {
            string test_encoding = "";
            switch (field.gettextencoding()) {
            case FieldTextEncoding.ISO_8859_1:
                test_encoding = "ISO-8859-1";
                break;
            case FieldTextEncoding.UTF_16:
                test_encoding = "UTF-16";
                break;
            case FieldTextEncoding.UTF_16BE:
                test_encoding = "UTF-16BE";
                break;
            case FieldTextEncoding.UTF_8:
                test_encoding = "UTF-8";
                break;
            default:
                test_encoding = "UNKNOWN";
                break;
            }
            stdout.printf("\t%s: %s\n",
                          ConsoleTools.blue("Textencoding"),
                          ConsoleTools.yellow(test_encoding));
        }

        private void analyze_stringlist(Field field) {
            for (int i = 0; i < field.stringlist.length; i++) {
                string s = UCS4.utf8duplicate(field.getstrings(i));
                stdout.printf("\t\t%s %s: \"%s\"\n",
                              ConsoleTools.blue("String"),
                              ConsoleTools.cyan("%d".printf(i)),
                              ConsoleTools.yellow(s));
            }
        }

        private void analyze_picture_type(Field field) {
            string ptype = "";
            switch (field.number_value) {
            case PictureType.OTHER:
                ptype = "Other";
                break;
            case PictureType.PNG32ICON:
                ptype = " 32x32 pixels 'file icon' (PNG only)";
                break;
            case PictureType.OTHERICON:
                ptype = "Other file icon";
                break;
            case PictureType.COVERFRONT:
                ptype = "Cover (front)";
                break;
            case PictureType.COVERBACK:
                ptype = "Cover (back)";
                break;
            case PictureType.LEAFLETPAGE:
                ptype = "Leaflet page";
                break;
            case PictureType.MEDIA:
                ptype = "Media (e.g. lable side of CD)";
                break;
            case PictureType.LEADARTIST:
                ptype = "Lead artist/lead performer/soloist";
                break;
            case PictureType.ARTIST:
                ptype = "Artist/performer";
                break;
            case PictureType.CONDUCTOR:
                ptype = "Conductor";
                break;
            case PictureType.BAND:
                ptype = "Band/Orchestra";
                break;
            case PictureType.COMPOSER:
                ptype = "Composer";
                break;
            case PictureType.LYRICIST:
                ptype = "Lyricist/text writer";
                break;
            case PictureType.REC_LOCATION:
                ptype = "Recording Location";
                break;
            case PictureType.RECORDING:
                ptype = "During recording";
                break;
            case PictureType.PERFORMANCE:
                ptype = "During performance";
                break;
            case PictureType.VIDEO:
                ptype = "Movie/video screen capture";
                break;
            case PictureType.FISH:
                ptype = "A bright coloured fish";
                break;
            case PictureType.ILLUSTRATION:
                ptype = "Illustration";
                break;
            case PictureType.ARTISTLOGO:
                ptype = "Band/artist logotype";
                break;
            case PictureType.PUBLISHERLOGO:
                ptype = "Publisher/Studio logotype";
                break;
            default:
                ptype = "UNKNONW";
                break;
            }
            stdout.printf("\t%s: \"%s\"\n",
                          ConsoleTools.blue("Picture type"),
                          ConsoleTools.yellow(ptype));
        }

        private void analyze_field(Frame frame, Field field) {
            int v;
            string s;
            switch (field.type) {
            case FieldType.TEXTENCODING:
                analyze_text_encoding(field);
                break;
            case FieldType.LATIN1:
                stdout.printf("\t%s: %s\n",
                              ConsoleTools.blue("Latin1"),
                              ConsoleTools.yellow(field.getlatin1()));
                break;
            case FieldType.LATIN1FULL:
                stdout.printf("\tLatin1 full\n");
                break;
            case FieldType.LATIN1LIST:
                stdout.printf("\tLatin1 list\n");
                break;
            case FieldType.STRING:
                s = UCS4.utf8duplicate(field.getstring());
                stdout.printf("\t%s: \"%s\"\n",
                              ConsoleTools.blue("String"),
                              ConsoleTools.yellow(s));
                break;
            case FieldType.STRINGFULL:
                s = UCS4.utf8duplicate(field.getfullstring());
                stdout.printf("\t%s: \"%s\"\n",
                              ConsoleTools.blue("String full"),
                              ConsoleTools.yellow(s));
                break;
            case FieldType.STRINGLIST:
                stdout.printf("\t%s\n", ConsoleTools.blue("String list"));
                analyze_stringlist(field);
                break;
            case FieldType.LANGUAGE:
                stdout.printf("\t%s: %s\n",
                              ConsoleTools.blue("Languaje"),
                              ConsoleTools.yellow((string)field.immediate_value));
                break;
            case FieldType.FRAMEID:
                stdout.printf("\tFrame id\n");
                break;
            case FieldType.DATE:
                stdout.printf("\tDate\n");
                break;
            case FieldType.INT8:
                v = (int)field.number_value;
                if (frame.id == FrameId.PICTURE) {
                    analyze_picture_type(field);
                } else if (frame.id == FrameId.POPULARIMETER) {
                    double r = v / 2.55;
                    stdout.printf("\t%s: %s\n",
                                  ConsoleTools.blue("Rating"),
                                  ConsoleTools.yellow("%g%%".printf(r)));
                } else {
                    stdout.printf("\t%s: %s\n",
                                  ConsoleTools.blue("UNKNOWN int8"),
                                  ConsoleTools.yellow("%d".printf(v)));
                }
                break;
            case FieldType.INT16:
                stdout.printf("\tInt16\n");
                break;
            case FieldType.INT24:
                stdout.printf("\tInt24\n");
                break;
            case FieldType.INT32:
                stdout.printf("\tInt32\n");
                break;
            case FieldType.INT32PLUS:
                v = (int)field.number_value;
                if (frame.id == FrameId.POPULARIMETER) {
                    stdout.printf("\t%s: %s\n",
                                  ConsoleTools.blue("Counter"),
                                  ConsoleTools.yellow("%d".printf(v)));
                } else {
                    stdout.printf("\t%s: %s\n",
                                  ConsoleTools.blue("UNKNOWN int32 plus"),
                                  ConsoleTools.yellow("%d".printf(v)));
                }
                break;
            case FieldType.BINARYDATA:
                stdout.printf("\t%s: %s bytes\n",
                              ConsoleTools.blue("Binary data"),
                              ConsoleTools.yellow("%d".printf(field.binary_data.length)));
                break;
            default:
                break;
            }
        }

        private void analyze_frame(Frame frame) {
            stdout.printf("%s %s: (%s)\n",
                          ConsoleTools.blue("Frame"),
                          ConsoleTools.yellow(frame.id),
                          ConsoleTools.cyan(frame.description));
            for (int i = 0; i < frame.fields.length; i++) {
                analyze_field(frame, frame.field(i));
            }
        }

        public void analyze() {
            if (!FileUtils.test(filename, FileTest.EXISTS)) {
                stderr.printf("%s: No such file.\n", filename);
                return;
            }
            File file = new File(filename, FileMode.READONLY);
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

        private static void use() {
            stdout.printf(
"""Use: mlm-analyze FILE ...

OPTIONS:
    --help              Print this help.
""");
            exit(1);
        }

        public static int main(string[] args) {
            var files = new Gee.ArrayList<string>();

            if (args.length < 2)
                use();

            for (int i = 1; i < args.length; i++) {
                if (args[i].has_prefix("--"))
                    use();
                files.add(args[i]);
            }

            foreach (string file in files) {
                Analyzer a = new Analyzer(file);
                a.analyze();
            }

            return 0;
        }
    }
}

