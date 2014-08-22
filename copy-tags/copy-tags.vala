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

    public class CopyTags {

        private string source;
        private string dest;

        public CopyTags(string source, string dest) {
            this.source = source;
            this.dest = dest;
        }

        public void copy() {
        }

        public static void error(string message) {
            stderr.printf("%s\n", message);
            exit(1);
        }

        public static void main(string[] args) {
            if (args.length != 3)
                error("Use: %s SOURCE.mp3 TARGET.mp3".printf(args[0]));

            string source = args[1];
            string dest = args[2];

            if (!FileUtils.test(source, FileTest.EXISTS))
                error("The file ‘%s’ does not exists.".printf(source));

            if (!FileUtils.test(dest, FileTest.EXISTS))
                error("The file ‘%s’ does not exists.".printf(dest));

            var ct = new CopyTags(source, dest);
            ct.copy();
        }
    }
}
