using Id3Tag;
using Gee;

namespace MLM {

    public class FileTags {

        private static const string ARTIST   = "TPE1";
        private static const string TITLE    = "TIT1";
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

        private File file;
        private Tag tag;

        public FileTags(string filename) {
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
                    comment = frame.get_text();
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
                    invalid_frames.add(frame);
                }
            }
        }

        ~FileTags() {
            if (file != null) {
                file.close();
                file = null;
            }
        }
    }
}
