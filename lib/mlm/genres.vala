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
     * Enumeration for genres.
     */
    public enum Genre {
        BLUES                  = 0,
        CLASSIC_ROCK           = 1,
        COUNTRY                = 2,
        DANCE                  = 3,
        DISCO                  = 4,
        FUNK                   = 5,
        GRUNGE                 = 6,
        HIP_HOP                = 7,
        JAZZ                   = 8,
        METAL                  = 9,
        NEW_AGE                = 10,
        OLDIES                 = 11,
        OTHER                  = 12,
        POP                    = 13,
        R_AND_B                = 14,
        RAP                    = 15,
        REGGAE                 = 16,
        ROCK                   = 17,
        TECHNO                 = 18,
        INDUSTRIAL             = 19,
        ALTERNATIVE            = 20,
        SKA                    = 21,
        DEATH_METAL            = 22,
        PRANKS                 = 23,
        SOUNDTRACK             = 24,
        EURO_TECHNO            = 25,
        AMBIENT                = 26,
        TRIP_HOP               = 27,
        VOCAL                  = 28,
        JAZZ_FUNK              = 29,
        FUSION                 = 30,
        TRANCE                 = 31,
        CLASSICAL              = 32,
        INSTRUMENTAL           = 33,
        ACID                   = 34,
        HOUSE                  = 35,
        GAME                   = 36,
        SOUND_CLIP             = 37,
        GOSPEL                 = 38,
        NOISE                  = 39,
        ALTERNROCK             = 40,
        BASS                   = 41,
        SOUL                   = 42,
        PUNK                   = 43,
        SPACE                  = 44,
        MEDITATIVE             = 45,
        INSTRUMENTAL_POP       = 46,
        INSTRUMENTAL_ROCK      = 47,
        ETHNIC                 = 48,
        GOTHIC                 = 49,
        DARKWAVE               = 50,
        TECHNO_INDUSTRIAL      = 51,
        ELECTRONIC             = 52,
        POP_FOLK               = 53,
        EURODANCE              = 54,
        DREAM                  = 55,
        SOUTHERN_ROCK          = 56,
        COMEDY                 = 57,
        CULT                   = 58,
        GANGSTA                = 59,
        TOP_40                 = 60,
        CHRISTIAN_RAP          = 61,
        POP_FUNK               = 62,
        JUNGLE                 = 63,
        NATIVE_AMERICAN        = 64,
        CABARET                = 65,
        NEW_WAVE               = 66,
        PSYCHADELIC            = 67,
        RAVE                   = 68,
        SHOWTUNES              = 69,
        TRAILER                = 70,
        LO_FI                  = 71,
        TRIBAL                 = 72,
        ACID_PUNK              = 73,
        ACID_JAZZ              = 74,
        POLKA                  = 75,
        RETRO                  = 76,
        MUSICAL                = 77,
        ROCK_AND_ROLL          = 78,
        HARD_ROCK              = 79,
        FOLK                   = 80,
        FOLK_ROCK              = 81,
        NATIONAL_FOLK          = 82,
        SWING                  = 83,
        FAST_FUSION            = 84,
        BEBOB                  = 85,
        LATIN                  = 86,
        REVIVAL                = 87,
        CELTIC                 = 88,
        BLUEGRASS              = 89,
        AVANTGARDE             = 90,
        GOTHIC_ROCK            = 91,
        PROGRESSIVE_ROCK       = 92,
        PSYCHEDELIC_ROCK       = 93,
        SYMPHONIC_ROCK         = 94,
        SLOW_ROCK              = 95,
        BIG_BAND               = 96,
        CHORUS                 = 97,
        EASY_LISTENING         = 98,
        ACOUSTIC               = 99,
        HUMOUR                 = 100,
        SPEECH                 = 101,
        CHANSON                = 102,
        OPERA                  = 103,
        CHAMBER_MUSIC          = 104,
        SONATA                 = 105,
        SYMPHONY               = 106,
        BOOTY_BASS             = 107,
        PRIMUS                 = 108,
        PORN_GROOVE            = 109,
        SATIRE                 = 110,
        SLOW_JAM               = 111,
        CLUB                   = 112,
        TANGO                  = 113,
        SAMBA                  = 114,
        FOLKLORE               = 115,
        BALLAD                 = 116,
        POWER_BALLAD           = 117,
        RHYTHMIC_SOUL          = 118,
        FREESTYLE              = 119,
        DUET                   = 120,
        PUNK_ROCK              = 121,
        DRUM_SOLO              = 122,
        A_CAPELLA              = 123,
        EURO_HOUSE             = 124,
        DANCE_HALL             = 125,
        GOA                    = 126,
        DRUM_AND_BASS          = 127,
        CLUB_HOUSE             = 128,
        HARDCORE               = 129,
        TERROR                 = 130,
        INDIE                  = 131,
        BRITPOP                = 132,
        NEGERPUNK              = 133,
        POLSK_PUNK             = 134,
        BEAT                   = 135,
        CHRISTIAN_GANGSTA_RAP  = 136,
        HEAVY_METAL            = 137,
        BLACK_METAL            = 138,
        CROSSOVER              = 139,
        CONTEMPORARY_CHRISTIAN = 140,
        CHRISTIAN_ROCK         = 141,
        MERENGUE               = 142,
        SALSA                  = 143,
        TRASH_METAL            = 144,
        ANIME                  = 145,
        JPOP                   = 146,
        SYNTHPOP               = 147;

        /**
         * Returns an array with all the genres.
         * @return an array with all the genres.
         */
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

        /**
         * Returns the genre of the string.
         * @param genre the genre.
         * @return the genre of the string, or -1 if there is no genre for the
         *         string.
         */
        public static int index_of(string genre) {
            for (int i = 0; i < total(); i++)
                if (genre == ((Genre)i).to_string())
                    return i;
            return -1;
        }

        /**
         * Returns the string representation of the genre.
         * @return the string representation of the genre.
         */
        public string to_string() {
            switch (this) {
            case BLUES:                  return "Blues";
            case CLASSIC_ROCK:           return "Classic Rock";
            case COUNTRY:                return "Country";
            case DANCE:                  return "Dance";
            case DISCO:                  return "Disco";
            case FUNK:                   return "Funk";
            case GRUNGE:                 return "Grunge";
            case HIP_HOP:                return "Hip-Hop";
            case JAZZ:                   return "Jazz";
            case METAL:                  return "Metal";
            case NEW_AGE:                return "New Age";
            case OLDIES:                 return "Oldies";
            case OTHER:                  return "Other";
            case POP:                    return "Pop";
            case R_AND_B:                return "R&B";
            case RAP:                    return "Rap";
            case REGGAE:                 return "Reggae";
            case ROCK:                   return "Rock";
            case TECHNO:                 return "Techno";
            case INDUSTRIAL:             return "Industrial";
            case ALTERNATIVE:            return "Alternative";
            case SKA:                    return "Ska";
            case DEATH_METAL:            return "Death Metal";
            case PRANKS:                 return "Pranks";
            case SOUNDTRACK:             return "Soundtrack";
            case EURO_TECHNO:            return "Euro-Techno";
            case AMBIENT:                return "Ambient";
            case TRIP_HOP:               return "Trip-Hop";
            case VOCAL:                  return "Vocal";
            case JAZZ_FUNK:              return "Jazz+Funk";
            case FUSION:                 return "Fusion";
            case TRANCE:                 return "Trance";
            case CLASSICAL:              return "Classical";
            case INSTRUMENTAL:           return "Instrumental";
            case ACID:                   return "Acid";
            case HOUSE:                  return "House";
            case GAME:                   return "Game";
            case SOUND_CLIP:             return "Sound Clip";
            case GOSPEL:                 return "Gospel";
            case NOISE:                  return "Noise";
            case ALTERNROCK:             return "AlternRock";
            case BASS:                   return "Bass";
            case SOUL:                   return "Soul";
            case PUNK:                   return "Punk";
            case SPACE:                  return "Space";
            case MEDITATIVE:             return "Meditative";
            case INSTRUMENTAL_POP:       return "Instrumental Pop";
            case INSTRUMENTAL_ROCK:      return "Instrumental Rock";
            case ETHNIC:                 return "Ethnic";
            case GOTHIC:                 return "Gothic";
            case DARKWAVE:               return "Darkwave";
            case TECHNO_INDUSTRIAL:      return "Techno-Industrial";
            case ELECTRONIC:             return "Electronic";
            case POP_FOLK:               return "Pop-Folk";
            case EURODANCE:              return "Eurodance";
            case DREAM:                  return "Dream";
            case SOUTHERN_ROCK:          return "Southern Rock";
            case COMEDY:                 return "Comedy";
            case CULT:                   return "Cult";
            case GANGSTA:                return "Gangsta";
            case TOP_40:                 return "Top 40";
            case CHRISTIAN_RAP:          return "Christian Rap";
            case POP_FUNK:               return "Pop/Funk";
            case JUNGLE:                 return "Jungle";
            case NATIVE_AMERICAN:        return "Native American";
            case CABARET:                return "Cabaret";
            case NEW_WAVE:               return "New Wave";
            case PSYCHADELIC:            return "Psychadelic";
            case RAVE:                   return "Rave";
            case SHOWTUNES:              return "Showtunes";
            case TRAILER:                return "Trailer";
            case LO_FI:                  return "Lo-Fi";
            case TRIBAL:                 return "Tribal";
            case ACID_PUNK:              return "Acid Punk";
            case ACID_JAZZ:              return "Acid Jazz";
            case POLKA:                  return "Polka";
            case RETRO:                  return "Retro";
            case MUSICAL:                return "Musical";
            case ROCK_AND_ROLL:          return "Rock & Roll";
            case HARD_ROCK:              return "Hard Rock";
            case FOLK:                   return "Folk";
            case FOLK_ROCK:              return "Folk-Rock";
            case NATIONAL_FOLK:          return "National Folk";
            case SWING:                  return "Swing";
            case FAST_FUSION:            return "Fast Fusion";
            case BEBOB:                  return "Bebob";
            case LATIN:                  return "Latin";
            case REVIVAL:                return "Revival";
            case CELTIC:                 return "Celtic";
            case BLUEGRASS:              return "Bluegrass";
            case AVANTGARDE:             return "Avantgarde";
            case GOTHIC_ROCK:            return "Gothic Rock";
            case PROGRESSIVE_ROCK:       return "Progressive Rock";
            case PSYCHEDELIC_ROCK:       return "Psychedelic Rock";
            case SYMPHONIC_ROCK:         return "Symphonic Rock";
            case SLOW_ROCK:              return "Slow Rock";
            case BIG_BAND:               return "Big Band";
            case CHORUS:                 return "Chorus";
            case EASY_LISTENING:         return "Easy Listening";
            case ACOUSTIC:               return "Acoustic";
            case HUMOUR:                 return "Humour";
            case SPEECH:                 return "Speech";
            case CHANSON:                return "Chanson";
            case OPERA:                  return "Opera";
            case CHAMBER_MUSIC:          return "Chamber Music";
            case SONATA:                 return "Sonata";
            case SYMPHONY:               return "Symphony";
            case BOOTY_BASS:             return "Booty Bass";
            case PRIMUS:                 return "Primus";
            case PORN_GROOVE:            return "Porn Groove";
            case SATIRE:                 return "Satire";
            case SLOW_JAM:               return "Slow Jam";
            case CLUB:                   return "Club";
            case TANGO:                  return "Tango";
            case SAMBA:                  return "Samba";
            case FOLKLORE:               return "Folklore";
            case BALLAD:                 return "Ballad";
            case POWER_BALLAD:           return "Power Ballad";
            case RHYTHMIC_SOUL:          return "Rhythmic Soul";
            case FREESTYLE:              return "Freestyle";
            case DUET:                   return "Duet";
            case PUNK_ROCK:              return "Punk Rock";
            case DRUM_SOLO:              return "Drum Solo";
            case A_CAPELLA:              return "A capella";
            case EURO_HOUSE:             return "Euro-House";
            case DANCE_HALL:             return "Dance Hall";
            case GOA:                    return "Goa";
            case DRUM_AND_BASS:          return "Drum & Bass";
            case CLUB_HOUSE:             return "Club-House";
            case HARDCORE:               return "Hardcore";
            case TERROR:                 return "Terror";
            case INDIE:                  return "Indie";
            case BRITPOP:                return "BritPop";
            case NEGERPUNK:              return "Negerpunk";
            case POLSK_PUNK:             return "Polsk Punk";
            case BEAT:                   return "Beat";
            case CHRISTIAN_GANGSTA_RAP:  return "Christian Gangsta Rap";
            case HEAVY_METAL:            return "Heavy Metal";
            case BLACK_METAL:            return "Black Metal";
            case CROSSOVER:              return "Crossover";
            case CONTEMPORARY_CHRISTIAN: return "Contemporary Christian";
            case CHRISTIAN_ROCK:         return "Christian Rock";
            case MERENGUE:               return "Merengue";
            case SALSA:                  return "Salsa";
            case TRASH_METAL:            return "Trash Metal";
            case ANIME:                  return "Anime";
            case JPOP:                   return "JPop";
            case SYNTHPOP:               return "Synthpop";
            default:                     return "Invalid genre";
            }
        }

        /**
         * Returns the total number of genres, 148.
         * @return 148, always.
         */
        public static int total() {
            return 148;
        }
    }
}
