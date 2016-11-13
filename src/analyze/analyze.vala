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

        private enum ExitCode {
            OK               = 0,
            INVALID_ARGUMENT = 1,
            MISSING_FILES    = 2;
        }

        private Id3Tag.Tag tag;
        private string filename;

        public Analyzer(string filename) {
            this.filename = filename;
        }

        private void analyze_text_encoding(Id3Tag.Field field) {
            string text_encoding = "";
            switch (field.gettextencoding()) {
            case Id3Tag.FieldTextEncoding.ISO_8859_1:
                text_encoding = "ISO-8859-1";
                break;
            case Id3Tag.FieldTextEncoding.UTF_16:
                text_encoding = "UTF-16";
                break;
            case Id3Tag.FieldTextEncoding.UTF_16BE:
                text_encoding = "UTF-16BE";
                break;
            case Id3Tag.FieldTextEncoding.UTF_8:
                text_encoding = "UTF-8";
                break;
            default:
                text_encoding = "UNKNOWN";
                break;
            }
            stdout.printf("%s: %s\n",
                          Util.color("Textencoding", Color.BLUE),
                          Util.color(text_encoding, Color.YELLOW));
        }

        private void analyze_stringlist(Id3Tag.Field field) {
            for (int i = 0; i < field.stringlist.length; i++) {
                string s = Id3Tag.UCS4.utf8duplicate(field.getstrings(i));
                stdout.printf("\t\t%s %s: \"%s\"\n",
                              Util.color("String", Color.BLUE),
                              Util.color("%d".printf(i), Color.CYAN),
                              Util.color(s, Color.YELLOW));
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
                          Util.color("Picture type", Color.BLUE),
                          Util.color(ptype, Color.YELLOW));
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
                              Util.color("Latin1", Color.BLUE),
                              Util.color(field.getlatin1(), Color.YELLOW));
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
                              Util.color("String", Color.BLUE),
                              Util.color(s, Color.YELLOW));
                break;
            case Id3Tag.FieldType.STRINGFULL:
                s = Id3Tag.UCS4.utf8duplicate(field.getfullstring());
                stdout.printf("\t%s: \"%s\"\n",
                              Util.color("String full", Color.BLUE),
                              Util.color(s, Color.YELLOW));
                break;
            case Id3Tag.FieldType.STRINGLIST:
                stdout.printf("\t%s\n", Util.color("String list", Color.BLUE));
                analyze_stringlist(field);
                break;
            case Id3Tag.FieldType.LANGUAGE:
                stdout.printf("\t%s: %s\n",
                              Util.color("Languaje", Color.BLUE),
                              Util.color((string)field.immediate_value, Color.YELLOW));
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
                                  Util.color("Rating", Color.BLUE),
                                  Util.color("%g%%".printf(r), Color.YELLOW));
                } else {
                    stdout.printf("\t%s: %s\n",
                                  Util.color("UNKNOWN int8", Color.BLUE),
                                  Util.color("%d".printf(v), Color.YELLOW));
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
                                  Util.color("Counter", Color.BLUE),
                                  Util.color("%d".printf(v), Color.YELLOW));
                } else {
                    stdout.printf("\t%s: %s\n",
                                  Util.color("UNKNOWN int32 plus", Color.BLUE),
                                  Util.color("%d".printf(v), Color.YELLOW));
                }
                break;
            case Id3Tag.FieldType.BINARYDATA:
                stdout.printf("\t%s: %s bytes\n",
                              Util.color("Binary data", Color.BLUE),
                              Util.color("%'d".printf(field.binary_data.length),
                                         Color.YELLOW));
                break;
            default:
                break;
            }
        }

        private void analyze_frame(Id3Tag.Frame frame) {
            stdout.printf("%s %s: (%s)\n",
                          Util.color("Frame", Color.BLUE),
                          Util.color(frame.id, Color.YELLOW),
                          Util.color(frame.description, Color.CYAN));
            for (int i = 0; i < frame.fields.length; i++)
                analyze_field(frame, frame.field(i));
        }

        public void analyze() {
            if (!FileUtils.test(filename, FileTest.EXISTS)) {
                stderr.printf("%s: No such file.\n", filename);
                return;
            }
            Id3Tag.File file = new Id3Tag.File(filename,
                                               Id3Tag.FileMode.READONLY);
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
            if (tag.frames.length == 0)
                stderr.printf("%s: File has no frames.\n", filename);
            for (int i = 0; i < tag.frames.length; i++)
                analyze_frame(tag.frames[i]);
            file.close();
        }

        private static const string CONTEXT =
            "[FILE...] - Analyze Id3v2.4.0 tags";

        public static int main(string[] args) {
            Util.set_locale(GLib.LocaleCategory.NUMERIC);
            try {
                var opt_context = new OptionContext(CONTEXT);
                opt_context.set_help_enabled(true);
                opt_context.parse(ref args);
            } catch (GLib.OptionError e) {
                Util.error(true, ExitCode.INVALID_ARGUMENT, args[0],
                           e.message);
            }

            if (args.length < 2)
                Util.error(true, ExitCode.MISSING_FILES, args[0],
                           "Missing MP3 file(s)");

            for (int i = 1; i < args.length; i++) {
                Analyzer a = new Analyzer(args[i]);
                a.analyze();
            }

            return ExitCode.OK;
        }
    }
}
