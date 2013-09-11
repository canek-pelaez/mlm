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
using Gee;

namespace MLM {

    public class FileTags {

        public string artist { get; private set; }
        public string title { get; private set; }
        public string album { get; private set; }
        public int year { get; private set; }
        public int track_number { get; private set; }
        public int track_count { get; private set; }
        public int disc_number { get; private set; }
        public int genre { get; private set; }
        public string comment { get; private set; }
        public string composer { get; private set; }
        public string original_artist { get; private set; }
        public uint8[] front_cover_picture { get; private set; }
        public string front_cover_picture_description { get; private set; }
        public uint8[] artist_picture { get; private set; }
        public string artist_picture_description { get; private set; }
        public bool has_tags { get; private set; }

        private string filename;
        private File file;
        private Tag tag;

        public FileTags(string filename) {
            this.filename = filename;
            read_tags();
        }

        public void update_artist(string artist) {
            if (artist == "" && this.artist == null)
                return;
            Frame artist_frame;
            if (artist == "") {
                artist_frame = tag.search_frame(FrameId.ARTIST);
                tag.detachframe(artist_frame);
                this.artist = null;
                return;
            }
            if (this.artist == null) {
                artist_frame = tag.create_text_frame(FrameId.ARTIST);
                tag.attachframe(artist_frame);
            } else {
                artist_frame = tag.search_frame(FrameId.ARTIST);
            }
            artist_frame.set_text(artist);
            this.artist = artist;
        }

        public void update_title(string title) {
            if (title == "" && this.title == null)
                return;
            Frame title_frame;
            if (title == "") {
                title_frame = tag.search_frame(FrameId.TITLE);
                tag.detachframe(title_frame);
                this.title = null;
                return;
            }
            if (this.title == null) {
                title_frame = tag.create_text_frame(FrameId.TITLE);
                tag.attachframe(title_frame);
            } else {
                title_frame = tag.search_frame(FrameId.TITLE);
            }
            title_frame.set_text(title);
            this.title = title;
        }

        public void update_album(string album) {
            if (album == "" && this.album == null)
                return;
            Frame album_frame;
            if (album == "") {
                album_frame = tag.search_frame(FrameId.ALBUM);
                tag.detachframe(album_frame);
                this.album = null;
                return;
            }
            if (this.album == null) {
                album_frame = tag.create_text_frame(FrameId.ALBUM);
                tag.attachframe(album_frame);
            } else {
                album_frame = tag.search_frame(FrameId.ALBUM);
            }
            album_frame.set_text(album);
            this.album = album;
        }

        public void update_composer(string composer) {
            if (composer == "" && this.composer == null)
                return;
            Frame composer_frame;
            if (composer == "") {
                composer_frame = tag.search_frame(FrameId.COMPOSER);
                tag.detachframe(composer_frame);
                this.composer = null;
                return;
            }
            if (this.composer == null) {
                composer_frame = tag.create_text_frame(FrameId.COMPOSER);
                tag.attachframe(composer_frame);
            } else {
                composer_frame = tag.search_frame(FrameId.COMPOSER);
            }
            composer_frame.set_text(composer);
            this.composer = composer;
        }

        public void update_original_artist(string original_artist) {
            if (original_artist == "" && this.original_artist == null)
                return;
            Frame original_artist_frame;
            if (original_artist == "") {
                original_artist_frame = tag.search_frame(FrameId.ORIGINAL);
                tag.detachframe(original_artist_frame);
                this.original_artist = null;
                return;
            }
            if (this.original_artist == null) {
                original_artist_frame = tag.create_text_frame(FrameId.ORIGINAL);
                tag.attachframe(original_artist_frame);
            } else {
                original_artist_frame = tag.search_frame(FrameId.ORIGINAL);
            }
            original_artist_frame.set_text(original_artist);
            this.original_artist = original_artist;
        }

        public void update_comment(string comment) {
            if (comment == "" && this.comment == null)
                return;
            Frame comment_frame;
            if (comment == "") {
                comment_frame = tag.search_frame(FrameId.COMMENT);
                tag.detachframe(comment_frame);
                this.comment = null;
                return;
            }
            if (this.comment == null) {
                comment_frame = tag.create_comment_frame("eng");
                tag.attachframe(comment_frame);
            } else {
                comment_frame = tag.search_frame(FrameId.COMMENT);
            }
            comment_frame.set_comment_text(comment);
            this.comment = comment;
        }

        public void update_year(int year) {
            if (year == this.year)
                return;
            Frame year_frame;
            if (year == -1) {
                year_frame = tag.search_frame(FrameId.YEAR);
                tag.detachframe(year_frame);
                this.year = -1;
                return;
            }
            if (this.year == -1) {
                year_frame = tag.create_text_frame(FrameId.YEAR);
                tag.attachframe(year_frame);
            } else {
                year_frame = tag.search_frame(FrameId.YEAR);
            }
            year_frame.set_text("%d".printf(year));
            this.year = year;
        }

        public void update_disc_number(int disc_number) {
            if (disc_number == this.disc_number)
                return;
            Frame disc_number_frame;
            if (disc_number == -1) {
                disc_number_frame = tag.search_frame(FrameId.DISC);
                tag.detachframe(disc_number_frame);
                this.disc_number = -1;
                return;
            }
            if (this.disc_number == -1) {
                disc_number_frame = tag.create_text_frame(FrameId.DISC);
                tag.attachframe(disc_number_frame);
            } else {
                disc_number_frame = tag.search_frame(FrameId.DISC);
            }
            disc_number_frame.set_text("%d".printf(disc_number));
            this.disc_number = disc_number;
        }

        public void update_track(int track_number, int track_count) {
            if (track_number == this.track_number &&
                track_count  == this.track_count)
                return;
            Frame track_frame;
            if (track_number == -1 && track_count == -1) {
                track_frame = tag.search_frame(FrameId.TRACK);
                tag.detachframe(track_frame);
                this.track_number = -1;
                this.track_count = -1;
                return;
            }
            if (this.track_number == -1 && this.track_count == -1) {
                track_frame = tag.create_text_frame(FrameId.TRACK);
                tag.attachframe(track_frame);
            } else {
                track_frame = tag.search_frame(FrameId.TRACK);
            }
            if (track_count == -1)
                track_frame.set_text("%02d".printf(track_number));
            else
                track_frame.set_text("%02d/%02d".printf(track_number, track_count));
            this.track_number = track_number;
            this.track_count = track_count;
        }

        public void update_genre(int genre) {
            if (genre == this.genre)
                return;
            Frame genre_frame;
            if (genre == -1) {
                genre_frame = tag.search_frame(FrameId.GENRE);
                tag.detachframe(genre_frame);
                this.genre = -1;
                return;
            }
            if (this.genre == -1) {
                genre_frame = tag.create_text_frame(FrameId.GENRE);
                tag.attachframe(genre_frame);
            } else {
                genre_frame = tag.search_frame(FrameId.GENRE);
            }
            genre_frame.set_text("%d".printf(genre));
            this.genre = genre;
        }

        public void update_front_cover_picture(uint8[]? fcp) {
            if (front_cover_picture == null && fcp == null)
                return;
            Frame fcp_frame;
            if (fcp == null) {
                fcp_frame = tag.search_picture_frame(PictureType.COVERFRONT);
                tag.detachframe(fcp_frame);
                front_cover_picture = null;
                return;
            }
            if (front_cover_picture == null) {
                fcp_frame = tag.create_picture_frame(PictureType.COVERFRONT);
                tag.attachframe(fcp_frame);
            } else {
                fcp_frame = tag.search_picture_frame(PictureType.COVERFRONT);
            }
            fcp_frame.set_picture(fcp, album != null ? album + " cover" : "");
            front_cover_picture = fcp;
        }

        public void update_artist_picture(uint8[]? ap) {
            if (artist_picture == null && ap == null)
                return;
            Frame ap_frame;
            if (ap == null) {
                ap_frame = tag.search_picture_frame(PictureType.ARTIST);
                tag.detachframe(ap_frame);
                artist_picture = null;
                return;
            }
            if (artist_picture == null) {
                ap_frame = tag.create_picture_frame(PictureType.ARTIST);
                tag.attachframe(ap_frame);
            } else {
                ap_frame = tag.search_picture_frame(PictureType.ARTIST);
            }
            ap_frame.set_picture(ap, artist != null ? artist : "");
            artist_picture = ap;
        }

        private void read_tags() {
            artist = title = album = comment = composer = original_artist = null;
            year = track_number = track_count = disc_number = genre = -1;
            front_cover_picture = artist_picture = null;
            front_cover_picture_description = artist_picture_description = null;
            has_tags = false;

            file = new File(filename, FileMode.READWRITE);
            tag = file.tag();
            if (tag.frames.length == 0)
                return;

            var invalid_frames = new ArrayList<Frame>();
            has_tags = tag.frames.length > 0;
            for (int i = 0; i < tag.frames.length; i++) {
                Frame frame = tag.frames[i];
                if (frame.id == FrameId.ARTIST) {
                    artist = frame.get_text();
                } else if (frame.id == FrameId.TITLE) {
                    title = frame.get_text();
                } else if (frame.id == FrameId.ALBUM) {
                    album = frame.get_text();
                } else if (frame.id == FrameId.YEAR) {
                    year = int.parse(frame.get_text());
                } else if (frame.id == FrameId.TRACK) {
                    string track = frame.get_text();
                    if (track.index_of("/") != -1) {
                        string[] t = track.split("/");
                        track_number = int.parse(t[0]);
                        track_count = int.parse(t[1]);
                    } else {
                        track_number = int.parse(track);
                        track_count = -1;
                    }
                } else if (frame.id == FrameId.DISC) {
                    disc_number = int.parse(frame.get_text());
                } else if (frame.id == FrameId.GENRE) {
                    string g = frame.get_text();
                    Genre[] genres = Genre.all();
                    for (int j = 0; j < genres.length; j++)
                        if (g == genres[j].to_string())
                            genre = j;
                    if (genre != -1)
                        continue;
                    int n = int.parse(g);
                    if (0 <= n && n < genres.length)
                        genre = n;
                    else
                        invalid_frames.add(frame);
                } else if (frame.id == FrameId.COMMENT) {
                    comment = frame.get_comment_text();
                } else if (frame.id == FrameId.COMPOSER) {
                    composer = frame.get_text();
                } else if (frame.id == FrameId.ORIGINAL) {
                    original_artist = frame.get_text();
                } else if (frame.id == FrameId.PICTURE) {
                    uint8[] fc_data = frame.get_picture(PictureType.COVERFRONT);
                    if (fc_data != null) {
                        front_cover_picture = fc_data;
                        front_cover_picture_description = frame.get_picture_description();
                    }
                    uint8[] a_data = frame.get_picture(PictureType.ARTIST);
                    if (a_data != null) {
                        artist_picture = a_data;
                        artist_picture_description = frame.get_picture_description();
                    }
                } else {
                    stderr.printf("Invalid frame '%s' will be deleted.\n", frame.id);
                    invalid_frames.add(frame);
                }
            }
            foreach (Frame frame in invalid_frames) {
                tag.detachframe(frame);
            }
        }

        /* libid3tag has no nice support for removing all tags. We
         * just remove the ID3v2.4 tag following
         *
         * http://id3lib.sourceforge.net/id3/id3v2.4.0-structure.txt */
        public void remove_tags() {
            file.close();
            file = null;
            tag = null;

            uint8[] bytes;
            try {
                FileUtils.get_data(filename, out bytes);
            } catch (FileError fe) {
                stderr.printf("There was an error reading from '%s'.\n", filename);
                return;
            }

            // Unzynch the size of the tag.
            uint a = bytes[6];
            uint b = bytes[7];
            uint c = bytes[8];
            uint d = bytes[9];
            uint size = ((a << 21) | (b << 14) | (c << 7) | d) + 10;

            uint8[] new_bytes = new uint8[bytes.length - size];
            for (int i = 0; i < new_bytes.length; i++)
                new_bytes[i] = bytes[i + size];

            FileStream file = FileStream.open(filename, "w");
            size_t r = file.write(new_bytes);
            if (r != new_bytes.length)
                stderr.printf("There was an error when removing tags from '%s'.\n", filename);

            read_tags();
        }

        public void update() {
            if (artist == null && title == null && album == null &&
                comment == null && composer == null && original_artist == null &&
                year == -1 && track_number == -1 && track_count == -1 &&
                disc_number == -1 && genre == -1 &&
                front_cover_picture == null && artist_picture == null &&
                front_cover_picture_description == null &&
                artist_picture_description == null) {
                remove_tags();
            } else {
                tag.options(TagOption.COMPRESSION, 0);
                file.update();
            }
        }

        ~FileTags() {
            if (file != null)
                file.close();
        }
    }
}
