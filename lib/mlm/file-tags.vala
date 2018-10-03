/*
 * This file is part of mlm.
 *
 * Copyright © 2013-2018 Canek Peláez Valdés
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

    namespace FrameId {
        public const string ARTIST   = "TPE1";
        public const string TITLE    = "TIT2";
        public const string ALBUM    = "TALB";
        public const string BAND     = "TPE2";
        public const string YEAR     = "TDRC";
        public const string TRACK    = "TRCK";
        public const string DISC     = "TPOS";
        public const string GENRE    = "TCON";
        public const string COMMENT  = "COMM";
        public const string COMPOSER = "TCOM";
        public const string ORIGINAL = "TOPE";
        public const string PICTURE  = "APIC";
        /* The following are added for completeness, but are not
         * really used by the suite. */
        public const string POPULARIMETER  = "POPM";
    }

    public class FileTags {

        private Gee.HashMap<string, string?> string_frames;
        private Gee.HashMap<string, int?> int_frames;
        private Gee.HashMap<int, GLib.Bytes> data_frames;

        public string artist {
            get { return _artist; }
            set { define_artist(value); }
        }
        private string _artist;

        public string band {
            get { return _band; }
            set { define_band(value); }
        }
        private string _band;

        public string title {
            get { return _title; }
            set { define_title(value); }
        }
        private string _title;

        public string album {
            get { return _album; }
            set { define_album(value); }
        }
        private string _album;

        public int year {
            get { return _year; }
            set { define_year(value);
            }
        }
        private int _year;

        public int track {
            get { return _track; }
            set { define_track_total(value, _total); }
        }
        private int _track;

        public int total {
            get { return _total; }
            set { define_track_total(_track, value); }
        }
        private int _total;

        public int disc {
            get { return _disc; }
            set { define_disc(value); }
        }
        private int _disc;

        public int genre {
            get { return _genre; }
            set { define_genre(value); }
        }
        private int _genre;

        public string comment {
            get { return _comment; }
            set { define_comment(value); }
        }
        private string _comment;

        public string composer {
            get { return _composer; }
            set { define_composer(value); }
        }
        private string _composer;

        public string original {
            get { return _original; }
            set { define_original(value); }
        }
        private string _original;

        public uint8[] cover_picture {
            get { return _cover_picture; }
            set { define_cover_picture(value); }
        }
        private uint8[] _cover_picture;

        public uint8[] artist_picture {
            get { return _artist_picture; }
            set { define_artist_picture(value); }
        }
        private uint8[] _artist_picture;

        public string cover_picture_description { get; private set; }
        public string artist_picture_description { get; private set; }
        public bool has_tags { get; private set; }

        private string filename;
        private GLib.TimeVal time;
        private Id3Tag.File file;
        private Id3Tag.Tag tag;

        public FileTags(string filename) {
            this.filename = filename;
            string_frames = new Gee.HashMap<string, string?>();
            int_frames = new Gee.HashMap<string, int?>();
            data_frames = new Gee.HashMap<int, GLib.Bytes>();
            read_tags();
        }

        private void read_tags() {
            _year = _track = _total = _disc = _genre = -1;
            time = Util.get_file_time(filename);

            file = new Id3Tag.File(filename, Id3Tag.FileMode.READWRITE);
            tag = file.tag();
            if (tag.frames.length == 0)
                return;

            var invalid_frames = new Gee.ArrayList<Id3Tag.Frame>();
            has_tags = tag.frames.length > 0;
            for (int i = 0; i < tag.frames.length; i++) {
                var frame = tag.frames[i];
                if (frame.id == FrameId.ARTIST) {
                    string_frames[FrameId.ARTIST] = _artist = frame.get_text();
                } else if (frame.id == FrameId.TITLE) {
                    string_frames[FrameId.TITLE] = _title = frame.get_text();
                } else if (frame.id == FrameId.ALBUM) {
                    string_frames[FrameId.ALBUM] = _album = frame.get_text();
                } else if (frame.id == FrameId.BAND) {
                    string_frames[FrameId.BAND] = _band = frame.get_text();
                } else if (frame.id == FrameId.YEAR) {
                    int_frames[FrameId.YEAR] = _year =
                        int.parse(frame.get_text());
                } else if (frame.id == FrameId.TRACK) {
                    string track = frame.get_text();
                    if (track == null)
                        continue;
                    string_frames[FrameId.TRACK] = track;
                    if (track.index_of("/") != -1) {
                        string[] t = track.split("/");
                        _track = int.parse(t[0]);
                        _total = int.parse(t[1]);
                    } else {
                        _track = int.parse(track);
                        _total = -1;
                    }
                } else if (frame.id == FrameId.DISC) {
                    _disc = int.parse(frame.get_text());
                } else if (frame.id == FrameId.GENRE) {
                    var g = frame.get_text();
                    if (g == null)
                        continue;
                    var genres = Genre.all();
                    for (int j = 0; j < genres.length; j++)
                        if (g == genres[j].to_string())
                            _genre = j;
                    if (_genre != -1) {
                        int_frames[FrameId.GENRE] = _genre;
                        continue;
                    }
                    int n = int.parse(g);
                    if (0 <= n && n < genres.length) {
                        _genre = n;
                        int_frames[FrameId.GENRE] = _genre;
                    } else {
                        invalid_frames.add(frame);
                    }
                } else if (frame.id == FrameId.COMMENT) {
                    string_frames[FrameId.COMMENT] = _comment =
                        frame.get_comment_text();
                } else if (frame.id == FrameId.COMPOSER) {
                    string_frames[FrameId.COMPOSER] = _composer =
                        frame.get_text();
                } else if (frame.id == FrameId.ORIGINAL) {
                    string_frames[FrameId.ORIGINAL] = _original =
                        frame.get_text();
                } else if (frame.id == FrameId.PICTURE) {
                    var fc_data =
                        frame.get_picture(Id3Tag.PictureType.COVERFRONT);
                    if (fc_data != null) {
                        _cover_picture = fc_data;
                        data_frames[Id3Tag.PictureType.COVERFRONT] =
                            new GLib.Bytes(fc_data);
                        cover_picture_description =
                            frame.get_picture_description();
                    }
                    var a_data = frame.get_picture(Id3Tag.PictureType.ARTIST);
                    if (a_data != null) {
                        _artist_picture = a_data;
                        data_frames[Id3Tag.PictureType.ARTIST] =
                            new GLib.Bytes(a_data);
                        artist_picture_description =
                            frame.get_picture_description();
                    }
                } else {
                    GLib.warning("Invalid frame ‘%s’ will be deleted.\n",
                                 frame.id);
                    invalid_frames.add(frame);
                }
            }
            foreach (Id3Tag.Frame frame in invalid_frames) {
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
            } catch (GLib.Error e) {
                GLib.warning("There was an error reading from ‘%s’.\n",
                             filename);
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

            GLib.FileStream file = GLib.FileStream.open(filename, "w");
            size_t r = file.write(new_bytes);
            if (r != new_bytes.length)
                GLib.warning("There was an error removing tags from ‘%s’.\n",
                             filename);
            file = null;

            Util.set_file_time(filename, time);

            read_tags();
        }

        public void update() {
            if (string_frames.is_empty && int_frames.is_empty &&
                data_frames.is_empty) {
                remove_tags();
            } else {
                tag.options(Id3Tag.TagOption.COMPRESSION, 0);
                file.update();
            }
        }

        ~FileTags() {
            if (file != null) {
                file.close();
                Util.set_file_time(filename, time);
            }
        }

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

        private void define_band(string? value) {
            define_text_value(FrameId.BAND, value);
            _band = string_frames.has_key(FrameId.BAND) ?
                string_frames[FrameId.BAND] : null;
        }

        private void define_title(string? value) {
            define_text_value(FrameId.TITLE, value);
            _title = string_frames.has_key(FrameId.TITLE) ?
                string_frames[FrameId.TITLE] : null;
        }

        private void define_album(string? value) {
            define_text_value(FrameId.ALBUM, value);
            _album = string_frames.has_key(FrameId.ALBUM) ?
                string_frames[FrameId.ALBUM] : null;
            var frame = tag.search_picture_frame(Id3Tag.PictureType.COVERFRONT);
            if (frame != null)
                frame.set_picture_description(value + " cover");
        }

        private void define_year(int value) {
            define_int_value(FrameId.YEAR, value);
            _year = int_frames.has_key(FrameId.YEAR) ?
                int_frames[FrameId.YEAR] : -1;
        }

        private void define_track_total(int new_track, int new_total) {
            if (new_total < new_track && new_track > 0)
                new_total = new_track;
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

        private void define_disc(int value) {
            define_int_value(FrameId.DISC, value);
            _disc = int_frames.has_key(FrameId.DISC) ?
                int_frames[FrameId.DISC] : -1;
        }

        private void define_genre(int value) {
            define_int_value(FrameId.GENRE, value);
            _genre = int_frames.has_key(FrameId.GENRE) ?
                int_frames[FrameId.GENRE] : -1;
        }

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

        private void define_composer(string? value) {
            define_text_value(FrameId.COMPOSER, value);
            _composer = string_frames.has_key(FrameId.COMPOSER) ?
                string_frames[FrameId.COMPOSER] : null;
        }

        private void define_original(string? value) {
            define_text_value(FrameId.ORIGINAL, value);
            _original = string_frames.has_key(FrameId.ORIGINAL) ?
                string_frames[FrameId.ORIGINAL] : null;
        }

        private void define_cover_picture(uint8[] value) {
            Id3Tag.PictureType pt = Id3Tag.PictureType.COVERFRONT;
            define_data_value(pt, value, (album != null) ?
                              album + " cover" : "");
            _cover_picture = data_frames.has_key(pt) ?
                data_frames[pt].get_data() : null;
        }

        private void define_artist_picture(uint8[] value) {
            Id3Tag.PictureType pt = Id3Tag.PictureType.ARTIST;
            define_data_value(pt, value, (artist != null) ? artist : "");
            _artist_picture = data_frames.has_key(pt) ?
                data_frames[pt].get_data() : null;
        }

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
