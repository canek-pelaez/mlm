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

    public class Analyze {

        private Tag tag;
        private string filename;

        public Analyze(string filename) {
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
            stdout.printf("\tTextencoding: %s\n", test_encoding);
        }

        private void analyze_field(Field field) {
            switch (field.type) {
            case FieldType.TEXTENCODING:
                analyze_text_encoding(field);
                break;
            case FieldType.LATIN1:
                stdout.printf("\tLatin1\n");
                break;
            case FieldType.LATIN1FULL:
                stdout.printf("\tLatin1 full\n");
                break;
            case FieldType.LATIN1LIST:
                stdout.printf("\tLatin1 list\n");
                break;
            case FieldType.STRING:
                string s = UCS4.utf8duplicate(field.getstring());
                stdout.printf("\tString: \"%s\"\n", s);
                break;
            case FieldType.STRINGFULL:
                stdout.printf("\tString full\n");
                break;
            case FieldType.STRINGLIST:
                stdout.printf("\tString list\n");
                break;
            case FieldType.LANGUAGE:
                stdout.printf("\tLanguaje\n");
                break;
            case FieldType.FRAMEID:
                stdout.printf("\tFrame id\n");
                break;
            case FieldType.DATE:
                stdout.printf("\tDate\n");
                break;
            case FieldType.INT8:
                stdout.printf("\tInt8\n");
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
                stdout.printf("\tInt32 plus\n");
                break;
            case FieldType.BINARYDATA:
                stdout.printf("\tBinary data\n");
                break;
            default:
                break;
            }
        }

        private void analyze_frame(Frame frame) {
            stdout.printf("Frame %s: %d\n", frame.id, frame.fields.length);
            for (int i = 0; i < frame.fields.length; i++) {
                analyze_field(frame.field(i));
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
                Analyze a = new Analyze(file);
                a.analyze();
            }

            return 0;
        }
    }
}

