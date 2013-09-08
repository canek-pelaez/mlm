using Id3Tag;

namespace MLM {

    public enum Genre {
        BLUES = 0,
        CLASSIC_ROCK,
        COUNTRY,
        DANCE,
        DISCO,
        FUNK,
        GRUNGE,
        HIP_HOP,
        JAZZ,
        METAL,
        NEW_AGE,
        OLDIES,
        OTHER,
        POP,
        R_AND_B,
        RAP,
        REGGAE,
        ROCK,
        TECHNO,
        INDUSTRIAL,
        ALTERNATIVE,
        SKA,
        DEATH_METAL,
        PRANKS,
        SOUNDTRACK,
        EURO_TECHNO,
        AMBIENT,
        TRIP_HOP,
        VOCAL,
        JAZZ_FUNK,
        FUSION,
        TRANCE,
        CLASSICAL,
        INSTRUMENTAL,
        ACID,
        HOUSE,
        GAME,
        SOUND_CLIP,
        GOSPEL,
        NOISE,
        ALTERNROCK,
        BASS,
        SOUL,
        PUNK,
        SPACE,
        MEDITATIVE,
        INSTRUMENTAL_POP,
        INSTRUMENTAL_ROCK,
        ETHNIC,
        GOTHIC,
        DARKWAVE,
        TECHNO_INDUSTRIAL,
        ELECTRONIC,
        POP_FOLK,
        EURODANCE,
        DREAM,
        SOUTHERN_ROCK,
        COMEDY,
        CULT,
        GANGSTA,
        TOP_40,
        CHRISTIAN_RAP,
        POP_FUNK,
        JUNGLE,
        NATIVE_AMERICAN,
        CABARET,
        NEW_WAVE,
        PSYCHADELIC,
        RAVE,
        SHOWTUNES,
        TRAILER,
        LO_FI,
        TRIBAL,
        ACID_PUNK,
        ACID_JAZZ,
        POLKA,
        RETRO,
        MUSICAL,
        ROCK_AND_ROLL,
        HARD_ROCK,
        FOLK,
        FOLK_ROCK,
        NATIONAL_FOLK,
        SWING,
        FAST_FUSION,
        BEBOB,
        LATIN,
        REVIVAL,
        CELTIC,
        BLUEGRASS,
        AVANTGARDE,
        GOTHIC_ROCK,
        PROGRESSIVE_ROCK,
        PSYCHEDELIC_ROCK,
        SYMPHONIC_ROCK,
        SLOW_ROCK,
        BIG_BAND,
        CHORUS,
        EASY_LISTENING,
        ACOUSTIC,
        HUMOUR,
        SPEECH,
        CHANSON,
        OPERA,
        CHAMBER_MUSIC,
        SONATA,
        SYMPHONY,
        BOOTY_BASS,
        PRIMUS,
        PORN_GROOVE,
        SATIRE,
        SLOW_JAM,
        CLUB,
        TANGO,
        SAMBA,
        FOLKLORE,
        BALLAD,
        POWER_BALLAD,
        RHYTHMIC_SOUL,
        FREESTYLE,
        DUET,
        PUNK_ROCK,
        DRUM_SOLO,
        A_CAPELLA,
        EURO_HOUSE,
        DANCE_HALL,
        GOA,
        DRUM_AND_BASS,
        CLUB_HOUSE,
        HARDCORE,
        TERROR,
        INDIE,
        BRITPOP,
        NEGERPUNK,
        POLSK_PUNK,
        BEAT,
        CHRISTIAN_GANGSTA_RAP,
        HEAVY_METAL,
        BLACK_METAL,
        CROSSOVER,
        CONTEMPORARY_CHRISTIAN,
        CHRISTIAN_ROCK,
        MERENGUE,
        SALSA,
        TRASH_METAL,
        ANIME,
        JPOP,
        SYNTHPOP;

        public static Genre[] all() {
            return { BLUES,
                    CLASSIC_ROCK,
                    COUNTRY,
                    DANCE,
                    DISCO,
                    FUNK,
                    GRUNGE,
                    HIP_HOP,
                    JAZZ,
                    METAL,
                    NEW_AGE,
                    OLDIES,
                    OTHER,
                    POP,
                    R_AND_B,
                    RAP,
                    REGGAE,
                    ROCK,
                    TECHNO,
                    INDUSTRIAL,
                    ALTERNATIVE,
                    SKA,
                    DEATH_METAL,
                    PRANKS,
                    SOUNDTRACK,
                    EURO_TECHNO,
                    AMBIENT,
                    TRIP_HOP,
                    VOCAL,
                    JAZZ_FUNK,
                    FUSION,
                    TRANCE,
                    CLASSICAL,
                    INSTRUMENTAL,
                    ACID,
                    HOUSE,
                    GAME,
                    SOUND_CLIP,
                    GOSPEL,
                    NOISE,
                    ALTERNROCK,
                    BASS,
                    SOUL,
                    PUNK,
                    SPACE,
                    MEDITATIVE,
                    INSTRUMENTAL_POP,
                    INSTRUMENTAL_ROCK,
                    ETHNIC,
                    GOTHIC,
                    DARKWAVE,
                    TECHNO_INDUSTRIAL,
                    ELECTRONIC,
                    POP_FOLK,
                    EURODANCE,
                    DREAM,
                    SOUTHERN_ROCK,
                    COMEDY,
                    CULT,
                    GANGSTA,
                    TOP_40,
                    CHRISTIAN_RAP,
                    POP_FUNK,
                    JUNGLE,
                    NATIVE_AMERICAN,
                    CABARET,
                    NEW_WAVE,
                    PSYCHADELIC,
                    RAVE,
                    SHOWTUNES,
                    TRAILER,
                    LO_FI,
                    TRIBAL,
                    ACID_PUNK,
                    ACID_JAZZ,
                    POLKA,
                    RETRO,
                    MUSICAL,
                    ROCK_AND_ROLL,
                    HARD_ROCK,
                    FOLK,
                    FOLK_ROCK,
                    NATIONAL_FOLK,
                    SWING,
                    FAST_FUSION,
                    BEBOB,
                    LATIN,
                    REVIVAL,
                    CELTIC,
                    BLUEGRASS,
                    AVANTGARDE,
                    GOTHIC_ROCK,
                    PROGRESSIVE_ROCK,
                    PSYCHEDELIC_ROCK,
                    SYMPHONIC_ROCK,
                    SLOW_ROCK,
                    BIG_BAND,
                    CHORUS,
                    EASY_LISTENING,
                    ACOUSTIC,
                    HUMOUR,
                    SPEECH,
                    CHANSON,
                    OPERA,
                    CHAMBER_MUSIC,
                    SONATA,
                    SYMPHONY,
                    BOOTY_BASS,
                    PRIMUS,
                    PORN_GROOVE,
                    SATIRE,
                    SLOW_JAM,
                    CLUB,
                    TANGO,
                    SAMBA,
                    FOLKLORE,
                    BALLAD,
                    POWER_BALLAD,
                    RHYTHMIC_SOUL,
                    FREESTYLE,
                    DUET,
                    PUNK_ROCK,
                    DRUM_SOLO,
                    A_CAPELLA,
                    EURO_HOUSE,
                    DANCE_HALL,
                    GOA,
                    DRUM_AND_BASS,
                    CLUB_HOUSE,
                    HARDCORE,
                    TERROR,
                    INDIE,
                    BRITPOP,
                    NEGERPUNK,
                    POLSK_PUNK,
                    BEAT,
                    CHRISTIAN_GANGSTA_RAP,
                    HEAVY_METAL,
                    BLACK_METAL,
                    CROSSOVER,
                    CONTEMPORARY_CHRISTIAN,
                    CHRISTIAN_ROCK,
                    MERENGUE,
                    SALSA,
                    TRASH_METAL,
                    ANIME,
                    JPOP,
                    SYNTHPOP };
        }

        public string to_string() {
            switch (this) {
            case BLUES: return "Blues";
            case CLASSIC_ROCK: return "Classic Rock";
            case COUNTRY: return "Country";
            case DANCE: return "Dance";
            case DISCO: return "Disco";
            case FUNK: return "Funk";
            case GRUNGE: return "Grunge";
            case HIP_HOP: return "Hip-Hop";
            case JAZZ: return "Jazz";
            case METAL: return "Metal";
            case NEW_AGE: return "New Age";
            case OLDIES: return "Oldies";
            case OTHER: return "Other";
            case POP: return "Pop";
            case R_AND_B: return "R&B";
            case RAP: return "Rap";
            case REGGAE: return "Reggae";
            case ROCK: return "Rock";
            case TECHNO: return "Techno";
            case INDUSTRIAL: return "Industrial";
            case ALTERNATIVE: return "Alternative";
            case SKA: return "Ska";
            case DEATH_METAL: return "Death Metal";
            case PRANKS: return "Pranks";
            case SOUNDTRACK: return "Soundtrack";
            case EURO_TECHNO: return "Euro-Techno";
            case AMBIENT: return "Ambient";
            case TRIP_HOP: return "Trip-Hop";
            case VOCAL: return "Vocal";
            case JAZZ_FUNK: return "Jazz+Funk";
            case FUSION: return "Fusion";
            case TRANCE: return "Trance";
            case CLASSICAL: return "Classical";
            case INSTRUMENTAL: return "Instrumental";
            case ACID: return "Acid";
            case HOUSE: return "House";
            case GAME: return "Game";
            case SOUND_CLIP: return "Sound Clip";
            case GOSPEL: return "Gospel";
            case NOISE: return "Noise";
            case ALTERNROCK: return "AlternRock";
            case BASS: return "Bass";
            case SOUL: return "Soul";
            case PUNK: return "Punk";
            case SPACE: return "Space";
            case MEDITATIVE: return "Meditative";
            case INSTRUMENTAL_POP: return "Instrumental Pop";
            case INSTRUMENTAL_ROCK: return "Instrumental Rock";
            case ETHNIC: return "Ethnic";
            case GOTHIC: return "Gothic";
            case DARKWAVE: return "Darkwave";
            case TECHNO_INDUSTRIAL: return "Techno-Industrial";
            case ELECTRONIC: return "Electronic";
            case POP_FOLK: return "Pop-Folk";
            case EURODANCE: return "Eurodance";
            case DREAM: return "Dream";
            case SOUTHERN_ROCK: return "Southern Rock";
            case COMEDY: return "Comedy";
            case CULT: return "Cult";
            case GANGSTA: return "Gangsta";
            case TOP_40: return "Top 40";
            case CHRISTIAN_RAP: return "Christian Rap";
            case POP_FUNK: return "Pop/Funk";
            case JUNGLE: return "Jungle";
            case NATIVE_AMERICAN: return "Native American";
            case CABARET: return "Cabaret";
            case NEW_WAVE: return "New Wave";
            case PSYCHADELIC: return "Psychadelic";
            case RAVE: return "Rave";
            case SHOWTUNES: return "Showtunes";
            case TRAILER: return "Trailer";
            case LO_FI: return "Lo-Fi";
            case TRIBAL: return "Tribal";
            case ACID_PUNK: return "Acid Punk";
            case ACID_JAZZ: return "Acid Jazz";
            case POLKA: return "Polka";
            case RETRO: return "Retro";
            case MUSICAL: return "Musical";
            case ROCK_AND_ROLL: return "Rock & Roll";
            case HARD_ROCK: return "Hard Rock";
            case FOLK: return "Folk";
            case FOLK_ROCK: return "Folk-Rock";
            case NATIONAL_FOLK: return "National Folk";
            case SWING: return "Swing";
            case FAST_FUSION: return "Fast Fusion";
            case BEBOB: return "Bebob";
            case LATIN: return "Latin";
            case REVIVAL: return "Revival";
            case CELTIC: return "Celtic";
            case BLUEGRASS: return "Bluegrass";
            case AVANTGARDE: return "Avantgarde";
            case GOTHIC_ROCK: return "Gothic Rock";
            case PROGRESSIVE_ROCK: return "Progressive Rock";
            case PSYCHEDELIC_ROCK: return "Psychedelic Rock";
            case SYMPHONIC_ROCK: return "Symphonic Rock";
            case SLOW_ROCK: return "Slow Rock";
            case BIG_BAND: return "Big Band";
            case CHORUS: return "Chorus";
            case EASY_LISTENING: return "Easy Listening";
            case ACOUSTIC: return "Acoustic";
            case HUMOUR: return "Humour";
            case SPEECH: return "Speech";
            case CHANSON: return "Chanson";
            case OPERA: return "Opera";
            case CHAMBER_MUSIC: return "Chamber Music";
            case SONATA: return "Sonata";
            case SYMPHONY: return "Symphony";
            case BOOTY_BASS: return "Booty Bass";
            case PRIMUS: return "Primus";
            case PORN_GROOVE: return "Porn Groove";
            case SATIRE: return "Satire";
            case SLOW_JAM: return "Slow Jam";
            case CLUB: return "Club";
            case TANGO: return "Tango";
            case SAMBA: return "Samba";
            case FOLKLORE: return "Folklore";
            case BALLAD: return "Ballad";
            case POWER_BALLAD: return "Power Ballad";
            case RHYTHMIC_SOUL: return "Rhythmic Soul";
            case FREESTYLE: return "Freestyle";
            case DUET: return "Duet";
            case PUNK_ROCK: return "Punk Rock";
            case DRUM_SOLO: return "Drum Solo";
            case A_CAPELLA: return "A capella";
            case EURO_HOUSE: return "Euro-House";
            case DANCE_HALL: return "Dance Hall";
            case GOA: return "Goa";
            case DRUM_AND_BASS: return "Drum & Bass";
            case CLUB_HOUSE: return "Club-House";
            case HARDCORE: return "Hardcore";
            case TERROR: return "Terror";
            case INDIE: return "Indie";
            case BRITPOP: return "BritPop";
            case NEGERPUNK: return "Negerpunk";
            case POLSK_PUNK: return "Polsk Punk";
            case BEAT: return "Beat";
            case CHRISTIAN_GANGSTA_RAP: return "Christian Gangsta Rap";
            case HEAVY_METAL: return "Heavy Metal";
            case BLACK_METAL: return "Black Metal";
            case CROSSOVER: return "Crossover";
            case CONTEMPORARY_CHRISTIAN: return "Contemporary Christian";
            case CHRISTIAN_ROCK: return "Christian Rock";
            case MERENGUE: return "Merengue";
            case SALSA: return "Salsa";
            case TRASH_METAL: return "Trash Metal";
            case ANIME: return "Anime";
            case JPOP: return "JPop";
            case SYNTHPOP: return "Synthpop";
            default: return "Invalid genre";
            }
        }
    }
}
