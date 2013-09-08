using Id3Tag;
using Gee;

namespace MLM {

    public class FileTags {

        private static const string ARTIST   = "TPE1";
        private static const string TITLE    = "TIT2";
        private static const string ALBUM    = "TALB";
        private static const string YEAR     = "TDRC";
        private static const string TRACK    = "TRCK";
        private static const string DISC     = "TPOS";
        private static const string GENRE    = "TCON";
        private static const string COMMENT  = "COMM";
        private static const string COMPOSER = "TCOM";
        private static const string ORIGINAL = "TOPE";
        private static const string PICTURE  = "APIC";

        public string artist { get; set; }
        public string title { get; set; }
        public string album { get; set; }
        public int year { get; set; }
        public int track_number { get; set; }
        public int track_count { get; set; }
        public int disc_number { get; set; }
        public int genre { get; set; }
        public string comment { get; set; }
        public string composer { get; set; }
        public string original_artist { get; set; }
        public uint8[] front_cover_picture { get; set; }
        public string front_cover_picture_description { get; set; }
        public uint8[] artist_picture { get; set; }
        public string artist_picture_description { get; set; }
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
                artist_frame = tag.search_frame(ARTIST);
                tag.detachframe(artist_frame);
                this.artist = null;
                return;
            }
            if (this.artist == null) {
                artist_frame = tag.create_text_frame(ARTIST);
                tag.attachframe(artist_frame);
            } else {
                artist_frame = tag.search_frame(ARTIST);
            }
            artist_frame.set_text(artist);
            this.artist = artist;
        }

        public void update_title(string title) {
            if (title == "" && this.title == null)
                return;
            Frame title_frame;
            if (title == "") {
                title_frame = tag.search_frame(TITLE);
                tag.detachframe(title_frame);
                this.title = null;
                return;
            }
            if (this.title == null) {
                title_frame = tag.create_text_frame(TITLE);
                tag.attachframe(title_frame);
            } else {
                title_frame = tag.search_frame(TITLE);
            }
            title_frame.set_text(title);
            this.title = title;
        }

        public void update_album(string album) {
            if (album == "" && this.album == null)
                return;
            Frame album_frame;
            if (album == "") {
                album_frame = tag.search_frame(ALBUM);
                tag.detachframe(album_frame);
                this.album = null;
                return;
            }
            if (this.album == null) {
                album_frame = tag.create_text_frame(ALBUM);
                tag.attachframe(album_frame);
            } else {
                album_frame = tag.search_frame(ALBUM);
            }
            album_frame.set_text(album);
            this.album = album;
        }

        public void update_original_artist(string original_artist) {
            if (original_artist == "" && this.original_artist == null)
                return;
            Frame original_artist_frame;
            if (original_artist == "") {
                original_artist_frame = tag.search_frame(ORIGINAL);
                tag.detachframe(original_artist_frame);
                this.original_artist = null;
                return;
            }
            if (this.original_artist == null) {
                original_artist_frame = tag.create_text_frame(ORIGINAL);
                tag.attachframe(original_artist_frame);
            } else {
                original_artist_frame = tag.search_frame(ORIGINAL);
            }
            original_artist_frame.set_text(original_artist);
            this.original_artist = original_artist;
        }

        public void update_comment(string comment) {
            if (comment == "" && this.comment == null)
                return;
            Frame comment_frame;
            if (comment == "") {
                comment_frame = tag.search_frame(COMMENT);
                tag.detachframe(comment_frame);
                this.comment = null;
                return;
            }
            if (this.comment == null) {
                comment_frame = tag.create_comment_frame("eng");
                tag.attachframe(comment_frame);
            } else {
                comment_frame = tag.search_frame(COMMENT);
            }
            comment_frame.set_comment_text(comment);
            this.comment = comment;
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
                if (frame.id == ARTIST) {
                    artist = frame.get_text();
                } else if (frame.id == TITLE) {
                    title = frame.get_text();
                } else if (frame.id == ALBUM) {
                    album = frame.get_text();
                } else if (frame.id == YEAR) {
                    year = int.parse(frame.get_text());
                } else if (frame.id == TRACK) {
                    string track = frame.get_text();
                    if (track.index_of("/") != -1) {
                        string[] t = track.split("/");
                        track_number = int.parse(t[0]);
                        track_count = int.parse(t[1]);
                    } else {
                        track_number = int.parse(track);
                        track_count = -1;
                    }
                } else if (frame.id == DISC) {
                    disc_number = int.parse(frame.get_text());
                } else if (frame.id == GENRE) {
                    string g = frame.get_text();
                    Genres[] genres = Genres.all();
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
                } else if (frame.id == COMMENT) {
                    comment = frame.get_comment_text();
                } else if (frame.id == COMPOSER) {
                    composer = frame.get_text();
                } else if (frame.id == ORIGINAL) {
                    original_artist = frame.get_text();
                } else if (frame.id == PICTURE) {
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
                    stderr.printf("Invalid fram '%s' will be deleted.\n", frame.id);
                    invalid_frames.add(frame);
                }
            }
        }

        /* libid3tag has no nice support for removing tags. We just
         * remove the ID3v2.4 tag following
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
                file.update();
            }
        }

        ~FileTags() {
            if (file != null)
                file.close();
        }
    }
}
