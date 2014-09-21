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

    public class CopyTags {

        private enum ReturnCode {
            OK               = 0,
            INVALID_ARGUMENT = 1,
            MISSING_ARGUMENT = 2,
            NO_SUCH_FILE     = 3
        }

        private string source;
        private string target;
        private FileTags source_tags;
        private FileTags target_tags;

        public CopyTags(string source, string target) {
            this.source = source;
            this.source_tags = new FileTags(source);
            this.target = target;
            this.target_tags = new FileTags(target);
        }

        public void copy() {
            var time = Util.get_file_time(source);

            if (source_tags.artist != null)
                target_tags.artist = source_tags.artist;
            if (source_tags.title != null)
                target_tags.title = source_tags.title;
            if (source_tags.album != null)
                target_tags.album = source_tags.album;
            target_tags.year = source_tags.year;
            if (source_tags.track != -1) {
                target_tags.track = source_tags.track;
                if (source_tags.total != -1)
                    target_tags.total = source_tags.total;
            }
            target_tags.disc = source_tags.disc;
            if (source_tags.genre != -1)
                target_tags.genre = source_tags.genre;
            if (source_tags.comment != null)
                target_tags.comment = source_tags.comment;
            if (source_tags.composer != null)
                target_tags.composer = source_tags.composer;
            if (source_tags.original != null)
                target_tags.original = source_tags.original;
            if (source_tags.front_cover_picture != null)
                target_tags.front_cover_picture = source_tags.front_cover_picture;
            if (source_tags.artist_picture != null)
                target_tags.artist_picture = source_tags.artist_picture;
            target_tags.update();
            target_tags = null;

            Util.set_file_time(source, time);
        }

        public static int error(string message,
                                int    return_code,
                                string command = "mlm-copy-tags",
                                bool   help = false) {
            stderr.printf("%s\n", message);
            if (help)
                stderr.printf("Run ‘%s --help’ for a list of options.\n".printf(command));
            return return_code;
        }

        public static int main(string[] args) {
            try {
                var opt = new GLib.OptionContext("SOURCE TARGET - Copy Id3v2.4.0 tags");
                opt.set_help_enabled(true);
                opt.parse(ref args);
            } catch (GLib.OptionError e) {
                return error(e.message, ReturnCode.INVALID_ARGUMENT,
                             args[0], true);
            }

            if (args.length != 3)
                return error("Missing SOURCE and/or TARGET",
                             ReturnCode.MISSING_ARGUMENT, args[0], true);

            string source = args[1];
            string target = args[2];

            if (!FileUtils.test(source, FileTest.EXISTS))
                return error("The source file ‘%s’ does not exists.".printf(source),
                             ReturnCode.NO_SUCH_FILE);

            if (!FileUtils.test(target, FileTest.EXISTS))
                return error("The target file ‘%s’ does not exists.".printf(target),
                             ReturnCode.NO_SUCH_FILE);

            var ct = new CopyTags(source, target);
            ct.copy();

            return ReturnCode.OK;
        }
    }
}
