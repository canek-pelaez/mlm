/*
 * This file is part of mlm.
 *
 * Copyright © 2013-2018 Canek Peláez Valdés
 *
 * This program is free software: you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option) any later
 * version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 * Author:
 *    Canek Peláez Valdés <canek@ciencias.unam.mx>
 */

namespace MLM {

    /**
     * Namespace for frame ids.
     */
    namespace FrameId {

        /**
         * The artist tag.
         */
        public const string ARTIST = "TPE1";

        /**
         * The title tag.
         */
        public const string TITLE = "TIT2";

        /**
         * The album tag.
         */
        public const string ALBUM = "TALB";

        /**
         * The band tag.
         */
        public const string BAND = "TPE2";

        /**
         * The year tag.
         */
        public const string YEAR = "TDRC";

        /**
         * The track tag.
         */
        public const string TRACK = "TRCK";

        /**
         * The disc tag.
         */
        public const string DISC = "TPOS";

        /**
         * The genre tag.
         */
        public const string GENRE = "TCON";

        /**
         * The comment tag.
         */
        public const string COMMENT = "COMM";

        /**
         * The composer tag.
         */
        public const string COMPOSER = "TCOM";

        /**
         * The original artist tag.
         */
        public const string ORIGINAL = "TOPE";

        /**
         * The picture tag.
         */
        public const string PICTURE = "APIC";
    }

    /**
     * Class for file tags.
     */
    public class FileTags {

        /* String frames. */
        private Gee.HashMap<string, string?> string_frames;
        /* Integer frames. */
        private Gee.HashMap<string, int?> int_frames;
        /* Data frames. */
        private Gee.HashMap<int, GLib.Bytes> data_frames;
        /* Invalid frames. */
        private Gee.ArrayList<Id3Tag.Frame> invalid_frames;

        /**
         * The artist.
         */
        public string artist {
            get { return _artist; }
            set { define_artist(value); }
        }
        private string _artist;

        /**
         * The band.
         */
        public string band {
            get { return _band; }
            set { define_band(value); }
        }
        private string _band;

        /**
         * The title.
         */
        public string title {
            get { return _title; }
            set { define_title(value); }
        }
        private string _title;

        /**
         * The album.
         */
        public string album {
            get { return _album; }
            set { define_album(value); }
        }
        private string _album;

        /**
         * The year.
         */
        public int year {
            get { return _year; }
            set { define_year(value);
            }
        }
        private int _year;

        /**
         * The track.
         */
        public int track {
            get { return _track; }
            set { define_track_total(value, _total); }
        }
        private int _track;

        /**
         * The total.
         */
        public int total {
            get { return _total; }
            set { define_track_total(_track, value); }
        }
        private int _total;

        /**
         * The disc.
         */
        public int disc {
            get { return _disc; }
            set { define_disc(value); }
        }
        private int _disc;

        /**
         * The genre.
         */
        public int genre {
            get { return _genre; }
            set { define_genre(value); }
        }
        private int _genre;

        /**
         * The comment.
         */
        public string comment {
            get { return _comment; }
            set { define_comment(value); }
        }
        private string _comment;

        /**
         * The composer.
         */
        public string composer {
            get { return _composer; }
            set { define_composer(value); }
        }
        private string _composer;

        /**
         * The original.
         */
        public string original {
            get { return _original; }
            set { define_original(value); }
        }
        private string _original;

        /**
         * The cover picture.
         */
        public uint8[] cover_picture {
            get { return _cover_picture; }
            set { define_cover_picture(value); }
        }
        private uint8[] _cover_picture;

        /**
         * The artist picture.
         */
        public uint8[] artist_picture {
            get { return _artist_picture; }
            set { define_artist_picture(value); }
        }
        private uint8[] _artist_picture;

        /**
         * The cover description.
         */
        public string cover_description { get; private set; }

        /**
         * The artist description.
         */
        public string artist_description { get; private set; }

        /**
         * Whether the file has tags.
         */
        public bool has_tags { public get { return tag.frames.length > 0; } }

        /* The path of the file. */
        private string path;
        /* The modification date of the file. */
        private GLib.TimeVal time;
        /* The file. */
        private Id3Tag.File file;
        /* The ID3 tag. */
        private Id3Tag.Tag tag;

        /**
         * Sets up a FileTags.
         * @param path the path of the file.
         */
        public FileTags(string path) {
            this.path = path;
            string_frames = new Gee.HashMap<string, string?>();
            int_frames = new Gee.HashMap<string, int?>();
            data_frames = new Gee.HashMap<int, GLib.Bytes>();
            read_tags();
        }

        /* Reads the tags from the file. */
        private void read_tags() {
            _year = _track = _total = _disc = _genre = -1;
            time = Util.get_file_time(path);

            file = new Id3Tag.File(path, Id3Tag.FileMode.READWRITE);
            tag = file.tag();
            if (tag.frames.length == 0)
                return;

            invalid_frames = new Gee.ArrayList<Id3Tag.Frame>();
            for (int i = 0; i < tag.frames.length; i++)
                set_frame(tag.frames[i]);
            foreach (Id3Tag.Frame frame in invalid_frames) {
                tag.detachframe(frame);
            }
            invalid_frames = null;
        }

        /* Sets a frame. */
        private void set_frame(Id3Tag.Frame frame) {
            if (frame.id == FrameId.ARTIST) {
                set_artist_frame(frame);
            } else if (frame.id == FrameId.TITLE) {
                set_title_frame(frame);
            } else if (frame.id == FrameId.ALBUM) {
                set_album_frame(frame);
            } else if (frame.id == FrameId.BAND) {
                set_band_frame(frame);
            } else if (frame.id == FrameId.YEAR) {
                set_year_frame(frame);
            } else if (frame.id == FrameId.TRACK) {
                set_track_frame(frame);
            } else if (frame.id == FrameId.DISC) {
                set_disc_frame(frame);
            } else if (frame.id == FrameId.GENRE) {
                set_genre_frame(frame);
            } else if (frame.id == FrameId.COMMENT) {
                set_comment_frame(frame);
            } else if (frame.id == FrameId.COMPOSER) {
                set_composer_frame(frame);
            } else if (frame.id == FrameId.ORIGINAL) {
                set_original_frame(frame);
            } else if (frame.id == FrameId.PICTURE) {
                set_picture_frame(frame);
            } else {
                set_invalid_frame(frame);
            }
        }

        /* Sets the artist frame. */
        private void set_artist_frame(Id3Tag.Frame frame) {
            string_frames[FrameId.ARTIST] = _artist = frame.get_text();
        }

        /* Sets the artist frame. */
        private void set_title_frame(Id3Tag.Frame frame) {
            string_frames[FrameId.TITLE] = _title = frame.get_text();
        }

        /* Sets the album frame. */
        private void set_album_frame(Id3Tag.Frame frame) {
            string_frames[FrameId.ALBUM] = _album = frame.get_text();
        }

        /* Sets the band frame. */
        private void set_band_frame(Id3Tag.Frame frame) {
            string_frames[FrameId.BAND] = _band = frame.get_text();
        }

        /* Sets the year frame. */
        private void set_year_frame(Id3Tag.Frame frame) {
            int_frames[FrameId.YEAR] = _year = int.parse(frame.get_text());
        }

        /* Sets the track frame. */
        private void set_track_frame(Id3Tag.Frame frame) {
                string track = frame.get_text();
                if (track == null)
                    return;
                string_frames[FrameId.TRACK] = track;
                if (track.index_of("/") != -1) {
                    string[] t = track.split("/");
                    _track = int.parse(t[0]);
                    _total = int.parse(t[1]);
                } else {
                    _track = int.parse(track);
                    _total = -1;
                }
        }

        /* Sets the disc frame. */
        private void set_disc_frame(Id3Tag.Frame frame) {
            int_frames[FrameId.DISC] = _disc = int.parse(frame.get_text());
        }

        /* Sets the genre frame. */
        private void set_genre_frame(Id3Tag.Frame frame) {
                var g = frame.get_text();
                if (g == null)
                    return;
                _genre = Genre.index_of(g);
                if (_genre != -1) {
                    int_frames[FrameId.GENRE] = _genre;
                    return;
                }
                int n = int.parse(g);
                if (0 <= n && n < Genre.total()) {
                    _genre = n;
                    int_frames[FrameId.GENRE] = _genre;
                } else {
                    invalid_frames.add(frame);
                }
        }

        /* Sets the comment frame. */
        private void set_comment_frame(Id3Tag.Frame frame) {
            _comment = frame.get_comment_text();
            string_frames[FrameId.COMMENT] = _comment;
        }

        /* Sets the composer frame. */
        private void set_composer_frame(Id3Tag.Frame frame) {
            _composer = frame.get_text();
            string_frames[FrameId.COMPOSER] = _composer;
        }

        /* Sets the original frame. */
        private void set_original_frame(Id3Tag.Frame frame) {
            _original = frame.get_text();
            string_frames[FrameId.ORIGINAL] = _original;
        }

        /* Sets the picture frame. */
        private void set_picture_frame(Id3Tag.Frame frame) {
                var fc_data =
                frame.get_picture(Id3Tag.PictureType.COVERFRONT);
                if (fc_data != null) {
                    _cover_picture = fc_data;
                    data_frames[Id3Tag.PictureType.COVERFRONT] =
                    new GLib.Bytes(fc_data);
                    cover_description =
                    frame.get_picture_description();
                }
                var a_data = frame.get_picture(Id3Tag.PictureType.ARTIST);
                if (a_data != null) {
                    _artist_picture = a_data;
                    data_frames[Id3Tag.PictureType.ARTIST] =
                    new GLib.Bytes(a_data);
                    artist_description =
                    frame.get_picture_description();
                }
        }

        /* Sets an invalid frame. */
        private void set_invalid_frame(Id3Tag.Frame frame) {
            GLib.warning("Invalid frame ‘%s’ will be deleted.\n", frame.id);
            invalid_frames.add(frame);
        }

        /**
         * Removes the tags from the file.
         *
         * libid3tag has no nice support for removing all tags. We just remove
         * the ID3v2.4 tag following:
         *
         * http://id3lib.sourceforge.net/id3/id3v2.4.0-structure.txt
         */
        public void remove_tags() {
            file.close();
            file = null;
            tag = null;

            uint8[] bytes;
            try {
                FileUtils.get_data(path, out bytes);
            } catch (GLib.Error e) {
                GLib.warning("There was an error reading from ‘%s’.", path);
                return;
            }

            /* Unzynch the size of the tag. */
            uint a = bytes[6];
            uint b = bytes[7];
            uint c = bytes[8];
            uint d = bytes[9];
            uint size = ((a << 21) | (b << 14) | (c << 7) | d) + 10;

            uint8[] new_bytes = new uint8[bytes.length - size];
            for (int i = 0; i < new_bytes.length; i++)
                new_bytes[i] = bytes[i + size];

            GLib.FileStream file = GLib.FileStream.open(path, "w");
            size_t r = file.write(new_bytes);
            if (r != new_bytes.length)
                GLib.warning("There was an error removing tags from ‘%s’.\n",
                             path);
            file = null;

            Util.set_file_time(path, time);

            read_tags();
        }

        /**
         * Updates the file.
         */
        public void update() {
            if (string_frames.is_empty && int_frames.is_empty &&
                data_frames.is_empty) {
                remove_tags();
            } else {
                tag.options(Id3Tag.TagOption.COMPRESSION, 0);
                file.update();
            }
        }

        /**
         * Frees resources for the file.
         */
        ~FileTags() {
            if (file != null) {
                file.close();
                Util.set_file_time(path, time);
            }
        }

        /* Defines the artist. */
        private void define_artist(string? value) {
            define_text_value(FrameId.ARTIST, value);
            _artist = string_frames.has_key(FrameId.ARTIST) ?
                string_frames[FrameId.ARTIST] : null;
            if (_artist == null)
                return;
            var frame = tag.search_picture_frame(Id3Tag.PictureType.ARTIST);
            if (frame != null)
                frame.set_picture_description(value);
        }

        /* Defines the band. */
        private void define_band(string? value) {
            define_text_value(FrameId.BAND, value);
            _band = string_frames.has_key(FrameId.BAND) ?
                string_frames[FrameId.BAND] : null;
        }

        /* Defines the title. */
        private void define_title(string? value) {
            define_text_value(FrameId.TITLE, value);
            _title = string_frames.has_key(FrameId.TITLE) ?
                string_frames[FrameId.TITLE] : null;
        }

        /* Defines the album. */
        private void define_album(string? value) {
            define_text_value(FrameId.ALBUM, value);
            _album = string_frames.has_key(FrameId.ALBUM) ?
                string_frames[FrameId.ALBUM] : null;
            var frame = tag.search_picture_frame(Id3Tag.PictureType.COVERFRONT);
            if (frame != null)
                frame.set_picture_description(value + " cover");
        }

        /* Defines the year. */
        private void define_year(int value) {
            define_int_value(FrameId.YEAR, value);
            _year = int_frames.has_key(FrameId.YEAR) ?
                int_frames[FrameId.YEAR] : -1;
        }

        /* Defines the track_total. */
        private void define_track_total(int new_track, int new_total) {
            if (new_total < new_track && new_track > 0)
                new_total = new_track;
            if (new_total > 0 && new_track < 0)
                new_total = -1;
            string value = (new_track == -1) ? null :
                "%d/%d".printf(new_total, new_track);
            define_text_value(FrameId.TRACK, value);
            if (string_frames.has_key(FrameId.TRACK)) {
                _track = new_track;
                _total = new_total;
            } else {
                _track = _total = -1;
            }
        }

        /* Defines the disc. */
        private void define_disc(int value) {
            define_int_value(FrameId.DISC, value);
            _disc = int_frames.has_key(FrameId.DISC) ?
                int_frames[FrameId.DISC] : -1;
        }

        /* Defines the genre. */
        private void define_genre(int value) {
            define_int_value(FrameId.GENRE, value);
            _genre = int_frames.has_key(FrameId.GENRE) ?
                int_frames[FrameId.GENRE] : -1;
        }

        /* Defines the comment. */
        private void define_comment(string? value) {
            Id3Tag.Frame frame;
            if (value == null || value == "") {
                if (string_frames.has_key(FrameId.COMMENT)) {
                    string_frames.unset(FrameId.COMMENT);
                    frame = tag.search_frame(FrameId.COMMENT);
                    tag.detachframe(frame);
                }
                return;
            }
            if (!string_frames.has_key(FrameId.COMMENT)) {
                frame = tag.create_comment_frame(FrameId.COMMENT);
                tag.attachframe(frame);
            } else {
                frame = tag.search_frame(FrameId.COMMENT);
            }
            frame.set_comment_text(value);
            string_frames[FrameId.COMMENT] = value;
            _comment = string_frames.has_key(FrameId.COMMENT) ?
                string_frames[FrameId.COMMENT] : null;
        }

        /* Defines the composer. */
        private void define_composer(string? value) {
            define_text_value(FrameId.COMPOSER, value);
            _composer = string_frames.has_key(FrameId.COMPOSER) ?
                string_frames[FrameId.COMPOSER] : null;
        }

        /* Defines the original. */
        private void define_original(string? value) {
            define_text_value(FrameId.ORIGINAL, value);
            _original = string_frames.has_key(FrameId.ORIGINAL) ?
                string_frames[FrameId.ORIGINAL] : null;
        }

        /* Defines the cover_picture. */
        private void define_cover_picture(uint8[] value) {
            Id3Tag.PictureType pt = Id3Tag.PictureType.COVERFRONT;
            define_data_value(pt, value, (album != null) ?
                              album + " cover" : "");
            _cover_picture = data_frames.has_key(pt) ?
                data_frames[pt].get_data() : null;
        }

        /* Defines the artist_picture. */
        private void define_artist_picture(uint8[] value) {
            Id3Tag.PictureType pt = Id3Tag.PictureType.ARTIST;
            define_data_value(pt, value, (artist != null) ? artist : "");
            _artist_picture = data_frames.has_key(pt) ?
                data_frames[pt].get_data() : null;
        }

        /* Defines the text_value. */
        private void define_text_value(string frame_id, string? value) {
            Id3Tag.Frame frame;
            if (value == null || value == "") {
                if (string_frames.has_key(frame_id)) {
                    string_frames.unset(frame_id);
                    frame = tag.search_frame(frame_id);
                    tag.detachframe(frame);
                }
                return;
            }
            if (!string_frames.has_key(frame_id)) {
                frame = tag.create_text_frame(frame_id);
                tag.attachframe(frame);
            } else {
                frame = tag.search_frame(frame_id);
            }
            frame.set_text(value);
            string_frames[frame_id] = value;
        }

        /* Defines the int_value. */
        private void define_int_value(string frame_id, int value) {
            Id3Tag.Frame frame;
            if (value == -1) {
                if (int_frames.has_key(frame_id)) {
                    int_frames.unset(frame_id);
                    frame = tag.search_frame(frame_id);
                    tag.detachframe(frame);
                }
                return;
            }
            if (!int_frames.has_key(frame_id)) {
                frame = tag.create_text_frame(frame_id);
                tag.attachframe(frame);
            } else {
                frame = tag.search_frame(frame_id);
            }
            frame.set_text("%d".printf(value));
            int_frames[frame_id] = value;
        }

        /* Defines the data_value. */
        private void define_data_value(Id3Tag.PictureType pt,
                                       uint8[] value,
                                       string? text) {
            Id3Tag.Frame frame;
            if (value == null) {
                if (data_frames.has_key(pt)) {
                    data_frames.unset(pt);
                    frame = tag.search_picture_frame(pt);
                    tag.detachframe(frame);
                }
                return;
            }
            if (!data_frames.has_key(pt)) {
                frame = tag.create_picture_frame(pt);
                tag.attachframe(frame);
            } else {
                frame = tag.search_picture_frame(pt);
            }
            frame.set_picture(value, text != null ? text : "");
            data_frames[pt] = new GLib.Bytes(value);
        }
    }
}
