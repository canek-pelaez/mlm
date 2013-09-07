using Id3Tag;
using Gee;

namespace MLM {

    public enum TagId {
        ARTIST,
        TITLE,
        ALBUM,
        YEAR,
        TRACK_NUMBER,
        TRACK_COUNT,
        DISC_NUMBER,
        GENRE,
        COMMENT,
        COMPOSER,
        ORIGINAL_ARTIST,
        FRONT_COVER_PICTURE,
        ARTIST_PICTURE;

        public static TagId[] all() {
            return { ARTIST,
                     TITLE,
                     ALBUM,
                     YEAR,
                     TRACK_NUMBER,
                     TRACK_COUNT,
                     DISC_NUMBER,
                     GENRE,
                     COMMENT,
                     COMPOSER,
                     ORIGINAL_ARTIST,
                     FRONT_COVER_PICTURE,
                     ARTIST_PICTURE };
        }

        public string to_string() {
            switch (this) {
            case ARTIST: return "TPE1";
            case TITLE: return "TIT2";
            case ALBUM: return "TALB";
            case YEAR: return "TDRC";
            case TRACK_NUMBER: return "TRCK";
            case TRACK_COUNT: return "TRCK";
            case DISC_NUMBER: return "TPOS";
            case GENRE: return "TCON";
            case COMMENT: return "COMM";
            case COMPOSER: return "TCOM";
            case ORIGINAL_ARTIST: return "TOPE";
            case FRONT_COVER_PICTURE: return "APIC";
            case ARTIST_PICTURE: return "APIC";
            default: return "INVALID";
            }
        }
    }

    public class FileTags {

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
        public uint8[] artist_picture { get; set; }

        public FileTags(Tag tag) {

            artist = title = album = comment = composer = original_artist = null;
            year = track_number = track_count = disc_number = genre = -1;
            front_cover_picture = artist_picture = null;

            var invalid_frames = new ArrayList<Frame>();
            for (int i = 0; i < tag.frames.length; i++) {
                Frame frame = tag.frames[i];
                if (frame.id == TagId.ARTIST.to_string()) {
                    artist = frame.get_text();
                } else if (frame.id == TagId.TITLE.to_string()) {
                    title = frame.get_text();
                } else if (frame.id == TagId.ALBUM.to_string()) {
                    album = frame.get_text();
                } else if (frame.id == TagId.YEAR.to_string()) {
                    year = int.parse(frame.get_text());
                } else if (frame.id == TagId.TRACK_NUMBER.to_string()) {
                    string track = frame.get_text();
                    if (track.index_of("/") != -1) {
                        string[] t = track.split("/");
                        track_number = int.parse(t[0]);
                        track_count = int.parse(t[1]);
                    } else {
                        track_number = int.parse(track);
                        track_count = -1;
                    }
                } else if (frame.id == TagId.DISC_NUMBER.to_string()) {
                    disc_number = int.parse(frame.get_text());
                } else if (frame.id == TagId.GENRE.to_string()) {
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
                } else if (frame.id == TagId.COMMENT.to_string()) {
                    comment = frame.get_text();
                } else if (frame.id == TagId.COMPOSER.to_string()) {
                    composer = frame.get_text();
                } else if (frame.id == TagId.ORIGINAL_ARTIST.to_string()) {
                    original_artist = frame.get_text();
                } else if (frame.id == TagId.FRONT_COVER_PICTURE.to_string()) {
                    Field f = frame.get_binary_field();
                    if (f != null)
                        front_cover_picture = f.binary_data;
                } else if (frame.id == TagId.ARTIST_PICTURE.to_string()) {
                    Field f = frame.get_binary_field();
                    if (f != null)
                        artist_picture = f.binary_data;
                } else {
                    invalid_frames.add(frame);
                }
            }
        }
    }
}
