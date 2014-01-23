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
                stdout.printf("Frame: %s\n", tag.frames[i].id);
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

