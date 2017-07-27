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
            set { define_track(value); }
        }
        private int _track;

        public int total {
            get { return _total; }
            set { define_total(value); }
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

        public uint8[] front_cover_picture {
            get { return _front_cover_picture; }
            set { define_front_cover_picture(value); }
        }
        private uint8[] _front_cover_picture;

        public uint8[] artist_picture {
            get { return _artist_picture; }
            set { define_artist_picture(value); }
        }
        private uint8[] _artist_picture;

        public string front_cover_picture_description { get; private set; }
        public string artist_picture_description { get; private set; }
        public bool has_tags { get; private set; }

        private string filename;
        private GLib.TimeVal time;
        private Id3Tag.File file;
        private Id3Tag.Tag tag;

        public FileTags(string filename) {
            this.filename = filename;
            read_tags();
        }

        private void read_tags() {
            _artist = _title = _album = _band = _comment = null;
            _composer = _original = null;
            _year = _track = _total = _disc = _genre = -1;
            _front_cover_picture = _artist_picture = null;
            front_cover_picture_description = null;
            artist_picture_description = null;
            has_tags = false;

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
                    _artist = frame.get_text();
                } else if (frame.id == FrameId.TITLE) {
                    _title = frame.get_text();
                } else if (frame.id == FrameId.ALBUM) {
                    _album = frame.get_text();
                } else if (frame.id == FrameId.BAND) {
                    _band = frame.get_text();
                } else if (frame.id == FrameId.YEAR) {
                    _year = int.parse(frame.get_text());
                } else if (frame.id == FrameId.TRACK) {
                    string track = frame.get_text();
                    if (track == null)
                        continue;
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
                    if (_genre != -1)
                        continue;
                    int n = int.parse(g);
                    if (0 <= n && n < genres.length)
                        _genre = n;
                    else
                        invalid_frames.add(frame);
                } else if (frame.id == FrameId.COMMENT) {
                    _comment = frame.get_comment_text();
                } else if (frame.id == FrameId.COMPOSER) {
                    _composer = frame.get_text();
                } else if (frame.id == FrameId.ORIGINAL) {
                    _original = frame.get_text();
                } else if (frame.id == FrameId.PICTURE) {
                    var fc_data = frame.get_picture(Id3Tag.PictureType.COVERFRONT);
                    if (fc_data != null) {
                        _front_cover_picture = fc_data;
                        front_cover_picture_description = frame.get_picture_description();
                    }
                    var a_data = frame.get_picture(Id3Tag.PictureType.ARTIST);
                    if (a_data != null) {
                        _artist_picture = a_data;
                        artist_picture_description = frame.get_picture_description();
                    }
                } else {
                    GLib.warning("Invalid frame ‘%s’ will be deleted.\n", frame.id);
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
            if (_artist == null && _title == null && _album == null &&
                _band == null && _comment == null && _composer == null &&
                _original == null && _year == -1 && _track == -1 &&
                _total == -1 && _disc == -1 && _genre == -1 &&
                _front_cover_picture == null && _artist_picture == null &&
                front_cover_picture_description == null &&
                artist_picture_description == null) {
                remove_tags();
            } else {
                tag.options(Id3Tag.TagOption.COMPRESSION, 0);
                file.update();
            }
        }

        private void define_artist(string a) {
            if (a == "" && _artist == null)
                return;
            Id3Tag.Frame artist_frame;
            if (a == "") {
                artist_frame = tag.search_frame(FrameId.ARTIST);
                tag.detachframe(artist_frame);
                _artist = null;
                return;
            }
            if (_artist == null) {
                artist_frame = tag.create_text_frame(FrameId.ARTIST);
                tag.attachframe(artist_frame);
            } else {
                artist_frame = tag.search_frame(FrameId.ARTIST);
            }
            _artist = a;
            artist_frame.set_text(_artist);
            if (artist_picture != null) {
                var ap_frame =
                    tag.search_picture_frame(Id3Tag.PictureType.ARTIST);
                ap_frame.set_picture_description(_artist);
            }
        }

        private void define_band(string b) {
            if (b == "" && _band == null)
                return;
            Id3Tag.Frame band_frame;
            if (b == "") {
                band_frame = tag.search_frame(FrameId.BAND);
                tag.detachframe(band_frame);
                _band = null;
                return;
            }
            if (_band == null) {
                band_frame = tag.create_text_frame(FrameId.BAND);
                tag.attachframe(band_frame);
            } else {
                band_frame = tag.search_frame(FrameId.BAND);
            }
            _band = b;
            band_frame.set_text(_band);
        }

        ~FileTags() {
            if (file != null) {
                file.close();
                Util.set_file_time(filename, time);
            }
        }

        private void define_title(string t) {
            if (t == "" && _title == null)
                return;
            Id3Tag.Frame title_frame;
            if (t == "") {
                title_frame = tag.search_frame(FrameId.TITLE);
                tag.detachframe(title_frame);
                _title = null;
                return;
            }
            if (_title == null) {
                title_frame = tag.create_text_frame(FrameId.TITLE);
                tag.attachframe(title_frame);
            } else {
                title_frame = tag.search_frame(FrameId.TITLE);
            }
            _title = t;
            title_frame.set_text(_title);
        }

        private void define_album(string a) {
            if (a == "" && _album == null)
                return;
            Id3Tag.Frame album_frame;
            if (a == "") {
                album_frame = tag.search_frame(FrameId.ALBUM);
                tag.detachframe(album_frame);
                _album = null;
                return;
            }
            if (_album == null) {
                album_frame = tag.create_text_frame(FrameId.ALBUM);
                tag.attachframe(album_frame);
            } else {
                album_frame = tag.search_frame(FrameId.ALBUM);
            }
            _album = a;
            album_frame.set_text(_album);
            if (front_cover_picture != null) {
                var fcp_frame = tag.search_picture_frame(Id3Tag.PictureType.COVERFRONT);
                fcp_frame.set_picture_description(_album + " cover");
            }
        }

        private void define_year(int y) {
            if (y == _year)
                return;
            Id3Tag.Frame year_frame;
            if (y == -1) {
                year_frame = tag.search_frame(FrameId.YEAR);
                tag.detachframe(year_frame);
                _year = -1;
                return;
            }
            if (_year == -1) {
                year_frame = tag.create_text_frame(FrameId.YEAR);
                tag.attachframe(year_frame);
            } else {
                year_frame = tag.search_frame(FrameId.YEAR);
            }
            _year = y;
            year_frame.set_text("%d".printf(_year));
        }

        private void define_track(int t) {
            if (t == _track)
                return;
            Id3Tag.Frame track_frame;
            if (t == -1) {
                track_frame = tag.search_frame(FrameId.TRACK);
                tag.detachframe(track_frame);
                _track = -1;
                _total = -1;
                return;
            }
            if (_track == -1) {
                track_frame = tag.create_text_frame(FrameId.TRACK);
                tag.attachframe(track_frame);
            } else {
                track_frame = tag.search_frame(FrameId.TRACK);
            }
            _track = t;
            if (_total == -1)
                track_frame.set_text("%02d".printf(_track));
            else
                track_frame.set_text("%02d/%02d".printf(_track, _total));
        }

        private void define_total(int t) {
            if (t == _total)
                return;
            Id3Tag.Frame track_frame;
            if (t == -1 && _track != -1) {
                track_frame = tag.search_frame(FrameId.TRACK);
                track_frame.set_text("%02d".printf(_track));
                _total = -1;
                return;
            }
            if (_track == -1)
                return;
            _total = t;
            track_frame = tag.search_frame(FrameId.TRACK);
            track_frame.set_text("%02d/%02d".printf(_track, _total));
        }

        private void define_disc(int d) {
            if (d == _disc)
                return;
            Id3Tag.Frame disc_frame;
            if (d == -1) {
                disc_frame = tag.search_frame(FrameId.DISC);
                tag.detachframe(disc_frame);
                _disc = -1;
                return;
            }
            if (_disc == -1) {
                disc_frame = tag.create_text_frame(FrameId.DISC);
                tag.attachframe(disc_frame);
            } else {
                disc_frame = tag.search_frame(FrameId.DISC);
            }
            _disc = d;
            disc_frame.set_text("%d".printf(_disc));
        }

        private void define_genre(int g) {
            if (g == _genre)
                return;
            Id3Tag.Frame genre_frame;
            if (g == -1) {
                genre_frame = tag.search_frame(FrameId.GENRE);
                tag.detachframe(genre_frame);
                _genre = -1;
                return;
            }
            if (_genre == -1) {
                genre_frame = tag.create_text_frame(FrameId.GENRE);
                tag.attachframe(genre_frame);
            } else {
                genre_frame = tag.search_frame(FrameId.GENRE);
            }
            _genre = g;
            genre_frame.set_text("%d".printf(_genre));
        }

        private void define_comment(string c) {
            if (c == "" && _comment == null)
                return;
            Id3Tag.Frame comment_frame;
            if (c == "") {
                comment_frame = tag.search_frame(FrameId.COMMENT);
                tag.detachframe(comment_frame);
                _comment = null;
                return;
            }
            if (_comment == null) {
                comment_frame = tag.create_comment_frame("eng");
                tag.attachframe(comment_frame);
            } else {
                comment_frame = tag.search_frame(FrameId.COMMENT);
            }
            _comment = c;
            comment_frame.set_comment_text(c);
        }

        private void define_composer(string c) {
            if (c == "" && _composer == null)
                return;
            Id3Tag.Frame composer_frame;
            if (c == "") {
                composer_frame = tag.search_frame(FrameId.COMPOSER);
                tag.detachframe(composer_frame);
                _composer = null;
                return;
            }
            if (_composer == null) {
                composer_frame = tag.create_text_frame(FrameId.COMPOSER);
                tag.attachframe(composer_frame);
            } else {
                composer_frame = tag.search_frame(FrameId.COMPOSER);
            }
            _composer = c;
            composer_frame.set_text(_composer);
        }

        private void define_original(string o) {
            if (o == "" && _original == null)
                return;
            Id3Tag.Frame original_artist_frame;
            if (o == "") {
                original_artist_frame = tag.search_frame(FrameId.ORIGINAL);
                tag.detachframe(original_artist_frame);
                _original = null;
                return;
            }
            if (_original == null) {
                original_artist_frame = tag.create_text_frame(FrameId.ORIGINAL);
                tag.attachframe(original_artist_frame);
            } else {
                original_artist_frame = tag.search_frame(FrameId.ORIGINAL);
            }
            _original = o;
            original_artist_frame.set_text(_original);
        }

        private void define_front_cover_picture(uint8[] f) {
            if (_front_cover_picture == null && f == null)
                return;
            Id3Tag.PictureType pt = Id3Tag.PictureType.COVERFRONT;
            Id3Tag.Frame fcp_frame;
            if (f == null) {
                fcp_frame = tag.search_picture_frame(pt);
                tag.detachframe(fcp_frame);
                _front_cover_picture = null;
                return;
            }
            if (_front_cover_picture == null) {
                fcp_frame = tag.create_picture_frame(pt);
                tag.attachframe(fcp_frame);
            } else {
                fcp_frame = tag.search_picture_frame(pt);
            }
            _front_cover_picture = f;
            fcp_frame.set_picture(_front_cover_picture,
                                  album != null ? album + " cover" : "");
        }

        private void define_artist_picture(uint8[] a) {
            if (_artist_picture == null && a == null)
                return;
            Id3Tag.PictureType pt = Id3Tag.PictureType.ARTIST;
            Id3Tag.Frame ap_frame;
            if (a == null) {
                ap_frame = tag.search_picture_frame(pt);
                tag.detachframe(ap_frame);
                _artist_picture = null;
                return;
            }
            if (_artist_picture == null) {
                ap_frame = tag.create_picture_frame(pt);
                tag.attachframe(ap_frame);
            } else {
                ap_frame = tag.search_picture_frame(pt);
            }
            _artist_picture = a;
            ap_frame.set_picture(_artist_picture,
                                 artist != null ? artist : "");
        }
    }
}
