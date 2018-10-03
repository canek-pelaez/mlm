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

        private enum ExitCode {
            OK,
            INVALID_ARGUMENT,
            MISSING_ARGUMENT,
            NO_SUCH_FILE;
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
            if (source_tags.cover_picture != null)
                target_tags.cover_picture = source_tags.cover_picture;
            if (source_tags.artist_picture != null)
                target_tags.artist_picture = source_tags.artist_picture;
            if (source_tags.band != null)
                target_tags.band = source_tags.band;
            target_tags.update();
            target_tags = null;

            Util.set_file_time(source, time);
        }

        private const string CONTEXT =
            "SOURCE TARGET - Copy Id3v2.4.0 tags";

        private const string DESCRIPTION =
            "The SOURCE and TARGET MP3 files need to exist.\n";

        public static int main(string[] args) {
            try {
                var opt = new GLib.OptionContext(CONTEXT);
                opt.set_help_enabled(true);
                opt.set_description(DESCRIPTION);
                opt.parse(ref args);
            } catch (GLib.OptionError e) {
                Util.error(true, ExitCode.INVALID_ARGUMENT, args[0],
                           e.message);
            }

            if (args.length != 3)
                Util.error(true, ExitCode.MISSING_ARGUMENT, args[0],
                           "Missing SOURCE and/or TARGET MP3 files");

            string source = args[1];
            string target = args[2];

            if (!FileUtils.test(source, FileTest.EXISTS))
                Util.error(false, ExitCode.NO_SUCH_FILE, args[0],
                           "The source file ‘%s’ does not exists.",
                           source);

            if (!FileUtils.test(target, FileTest.EXISTS))
                Util.error(false, ExitCode.NO_SUCH_FILE, args[0],
                           "The target file ‘%s’ does not exists.",
                           target);

            var ct = new CopyTags(source, target);
            ct.copy();

            return ExitCode.OK;
        }
    }
}
