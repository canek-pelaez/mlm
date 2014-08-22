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
            if (source_tags.artist != null)
                target_tags.update_artist(source_tags.artist);
            if (source_tags.title != null)
                target_tags.update_title(source_tags.title);
            if (source_tags.album != null)
                target_tags.update_album(source_tags.album);
            target_tags.update_year(source_tags.year);
            if (source_tags.track_number != -1 &&
                source_tags.track_count != -1)
                target_tags.update_track(source_tags.track_number,
                                         source_tags.track_count);
            target_tags.update_disc_number(source_tags.disc_number);
            if (source_tags.genre != -1)
                target_tags.update_genre(source_tags.genre);
            if (source_tags.comment != null)
                target_tags.update_comment(source_tags.comment);
            if (source_tags.composer != null)
                target_tags.update_composer(source_tags.composer);
            if (source_tags.original_artist != null)
                target_tags.update_original_artist(source_tags.original_artist);
            if (source_tags.front_cover_picture != null)
                target_tags.update_front_cover_picture(source_tags.front_cover_picture);
            if (source_tags.artist_picture != null)
                target_tags.update_artist_picture(source_tags.artist_picture);
            target_tags.update();
        }

        public static void error(string message) {
            stderr.printf("%s\n", message);
            exit(1);
        }

        public static void main(string[] args) {
            if (args.length != 3)
                error("Use: %s SOURCE.mp3 TARGET.mp3".printf(args[0]));

            string source = args[1];
            string target = args[2];

            if (!FileUtils.test(source, FileTest.EXISTS))
                error("The file ‘%s’ does not exists.".printf(source));

            if (!FileUtils.test(target, FileTest.EXISTS))
                error("The file ‘%s’ does not exists.".printf(target));

            var ct = new CopyTags(source, target);
            ct.copy();
        }
    }
}
