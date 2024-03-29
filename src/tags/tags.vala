/*
 * This file is part of mlm.
 *
 * Copyright © 2013-2019 Canek Peláez Valdés
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

    public class Tags {

        private enum PictureType {
            COVER,
            ARTIST;
        }

        private const int MIN_YEAR  = 1900;
        private const int MIN_TRACK = 1;
        private const int MAX_TRACK = 99;
        private const int MIN_DISC  = 1;
        private const int MAX_DISC  = 99;

        private static string prog_name = null;

        private static string  artist;
        private static string  title;
        private static string  album;
        private static string  band;
        private static string  s_year;
        private static int     year;
        private static string  s_track;
        private static int     track;
        private static string  s_total;
        private static int     total;
        private static string  s_disc;
        private static int     disc;
        private static string  s_genre;
        private static int     genre;
        private static string  comment;
        private static string  composer;
        private static string  original;
        private static string  cover_picture;
        private static uint8[] cover_picture_data;
        private static string  artist_picture;
        private static uint8[] artist_picture_data;
        private static bool    remove;
        private static string  format;
        private static bool    genres;
        private static string  out_cover_picture;
        private static string  out_artist_picture;

        private static int     current_year = 2019;

        private const GLib.OptionEntry[] options = {
            { "artist", 'a', 0, GLib.OptionArg.STRING,
              ref artist, "Artist name", "ARTIST" },
            { "title", 't', 0, GLib.OptionArg.STRING,
              ref title, "Track title", "DIRECTORY" },
            { "album", 'l', 0, GLib.OptionArg.STRING,
              ref album, "Album name", "ALBUM" },
            { "band", 'b', 0, GLib.OptionArg.STRING,
              ref band, "Album band", "BAND" },
            { "year", 'y', 0, GLib.OptionArg.STRING,
              ref s_year, "Release year", "YEAR" },
            { "track", 'n', 0, GLib.OptionArg.STRING,
              ref s_track, "Track number", "TRACK" },
            { "total", '#', 0, GLib.OptionArg.STRING,
              ref s_total, "Track total", "TOTAL" },
            { "disc", 'd', 0, GLib.OptionArg.STRING,
              ref s_disc, "Disc number", "DISC" },
            { "genre", 'g', 0, GLib.OptionArg.STRING,
              ref s_genre, "Genre", "GENRE" },
            { "comment", 'c', 0, GLib.OptionArg.STRING,
              ref comment, "Comment", "COMMENT" },
            { "composer", 's', 0, GLib.OptionArg.STRING,
              ref composer, "Composer", "COMPOSER" },
            { "original-artist", 'o', 0, GLib.OptionArg.STRING,
              ref original, "Original artist", "ARTIST" },
            { "cover-picture", 'f', 0, GLib.OptionArg.FILENAME,
              ref cover_picture, "Front cover picture", "FILENAME" },
            { "artist-picture", 'u', 0, GLib.OptionArg.FILENAME,
              ref artist_picture, "Artist picture", "FILENAME" },
            { "remove", 'r', 0, GLib.OptionArg.NONE,
              ref remove, "Remove tags from file", null },
            { "print", 'p', 0, GLib.OptionArg.STRING,
              ref format, "Formated print", "FORMAT" },
            { "genres", 'G', 0, GLib.OptionArg.NONE,
              ref genres, "Print supported genres", null },
            { "output-cover-picture", 'F', 0, GLib.OptionArg.FILENAME,
              ref out_cover_picture, "Save the front cover picture",
              "FILENAME" },
            { "output-artist-picture", 'A', 0, GLib.OptionArg.FILENAME,
              ref out_artist_picture, "Save the artist picture",
              "FILENAME" },
            { null }
        };

        private const string CONTEXT =
            "[FILENAME...] - Edit and show MP3 files tags";
        private const string DESCRIPTION =
"""With no flags the standard tags are printed. An empty string as parameter
removes an individual tag. You can only use the -F or -A flags with one MP3
file.

Format for printing:

  %a: Artist name
  %t: Track title
  %l: Album name
  %b: Album band
  %y: Release year
  %n: Track number
  %N: Track number (zero padded)
  %#: Track total
  %C: Track total (zero padded)
  %d: Disc number
  %D: Disc number (zero padded)
  %g: Genre
  %c: Comment
  %s: Composer
  %o: Original artist
  %f: File name
""";

        private static void print_genres() {
            var genres = Genre.all();
            stdout.printf("Supported genres:\n");
            for (int i = 0; i < genres.length; i++)
                stdout.printf("   %s %s\n",
                              Util.color("%03d".printf(i), Color.BLUE),
                              Util.color(genres[i].to_string(), Color.YELLOW));
            Process.exit(ExitCode.A_OK);
        }

        private static void print_standard_tags(string filename) {
            if (!FileUtils.test(filename, FileTest.EXISTS)) {
                stderr.printf("No such file: ‘%s’\n", filename);
                return;
            }
            var file_tags = new FileTags(filename);
            if (!file_tags.has_tags) {
                stderr.printf("The file ‘%s’ has no ID3 v2.4.0 tags.\n",
                              filename);
                return;
            }
            var box = new PrettyBox(80, Color.RED);
            box.set_title(GLib.Filename.display_basename(filename), Color.CYAN);
            if (file_tags.artist != null)
                box.add_body_key_value("Artist", file_tags.artist);
            if (file_tags.title != null)
                box.add_body_key_value("Title", file_tags.title);
            if (file_tags.album != null)
                box.add_body_key_value("Album", file_tags.album);
            if (file_tags.band != null)
                box.add_body_key_value("Album band", file_tags.band);
            if (file_tags.year != -1)
                box.add_body_key_value("Year", "%d".printf(file_tags.year));
            int n = file_tags.track, t = file_tags.total;
            if (file_tags.track != -1) {
                if (file_tags.total != -1)
                    box.add_body_key_value("Track", "%d of %d".printf(n, t));
                else
                    box.add_body_key_value("Track", "%d".printf(n));
            }
            int d = file_tags.disc;
            if (file_tags.disc != -1)
                box.add_body_key_value("Disc number", "%d".printf(d));
            var genres = Genre.all();
            if (file_tags.genre != -1)
                box.add_body_key_value("Genre", genres[file_tags.genre].to_string());
            if (file_tags.comment != null)
                box.add_body_key_value("Comment", file_tags.comment);
            if (file_tags.composer != null)
                box.add_body_key_value("Composer", file_tags.composer);
            if (file_tags.original != null)
                box.add_body_key_value("Original artist", file_tags.original);
            var desc = file_tags.cover_description;
            if (file_tags.cover_picture != null)
                box.add_body_key_value("Front cover picture", desc);
            desc = file_tags.artist_description;
            if (file_tags.artist_picture != null)
                box.add_body_key_value("Artist picture", desc);
            stdout.printf("%s", box.to_string());
        }

        private static void print_tags(string filename, string format) {
            if (!FileUtils.test(filename, FileTest.EXISTS)) {
                stderr.printf("No such file: ‘%s’\n", filename);
                return;
            }
            var ft = new FileTags(filename);
            if (!ft.has_tags) {
                stderr.printf("The file ‘%s’ has no ID3 v2.4.0 tags.\n",
                              filename);
                return;
            }

            var g = Genre.all();
            var f = format;

            f = f.replace("\\n", "\n");
            f = f.replace("\\t", "\t");
            if (ft.artist != null)
                f = f.replace("%a", ft.artist);
            if (ft.title != null)
                f = f.replace("%t", ft.title);
            if (ft.album != null)
                f = f.replace("%l", ft.album);
            if (ft.band != null)
                f = f.replace("%b", ft.band);
            if (ft.year != -1)
                f = f.replace("%y", "%d".printf(ft.year));
            if (ft.track != -1) {
                f = f.replace("%n", "%d".printf(ft.track));
                f = f.replace("%N", "%02d".printf(ft.track));
            }
            if (ft.total != -1) {
                f = f.replace("%#", "%d".printf(ft.total));
                f = f.replace("%C", "%02d".printf(ft.total));
            }
            if (ft.disc != -1) {
                f = f.replace("%d", "%d".printf(ft.disc));
                f = f.replace("%D", "%02d".printf(ft.disc));
            }
            if (ft.genre != -1)
                f = f.replace("%g", g[ft.genre].to_string());
            if (ft.comment != null)
                f = f.replace("%c", ft.comment);
            if (ft.composer != null)
                f = f.replace("%s", ft.composer);
            if (ft.original != null)
                f = f.replace("%o", ft.original);
            f = f.replace("%f", filename);

            stdout.printf(f);
        }

        private static void remove_tags(string filename) {
            stderr.printf("Removing tags from ‘%s’...\n", filename);
            if (!FileUtils.test(filename, FileTest.EXISTS)) {
                stderr.printf("No such file: ‘%s’\n", filename);
                return;
            }
            var ft = new FileTags(filename);
            if (!ft.has_tags) {
                stderr.printf("The file ‘%s’ has no ID3 v2.4.0 tags.\n",
                              filename);
                return;
            }
            ft.remove_tags();
        }

        private static void save_picture(string      filename,
                                         string      picture,
                                         PictureType picture_type) {
            if (!FileUtils.test(filename, FileTest.EXISTS))
                Util.error(false, ExitCode.NO_IMAGE_FILE, prog_name,
                           "No such file: ‘%s’", filename);
            if (!picture.has_suffix(".jpg"))
                Util.error(false, ExitCode.INVALID_IMAGE_FILE, prog_name,
                           "The file ‘%s’ does not have a ‘.jpg’ extension.",
                           picture);
            var file_tags = new FileTags(filename);
            if (!file_tags.has_tags)
                Util.error(false, ExitCode.NO_ID3_TAGS, prog_name,
                           "The file ‘%s’ has no ID3 v2.4.0 tags.",
                           filename);
            unowned uint8[] data = null;
            string type = null;
            switch (picture_type) {
            case PictureType.COVER:
                data = file_tags.cover_picture;
                type = "front cover";
                break;
            case PictureType.ARTIST:
                data = file_tags.artist_picture;
                type = "artist";
                break;
            }
            if (data == null)
                Util.error(false, ExitCode.NO_ID3_PICTURE, prog_name,
                           "The file ‘%s’ has no %s picture.", filename, type);
            GLib.FileStream file = GLib.FileStream.open(picture, "w");
            if (file == null)
                Util.error(false, ExitCode.WRITING_ERROR, prog_name,
                           "There was an error writing to ‘%s’.", picture);
            file.write(data);
            file = null;
        }

        private static void update_tags(string filename) {
            if (!FileUtils.test(filename, FileTest.EXISTS))
                Util.error(false, ExitCode.NO_SUCH_FILE, prog_name,
                           "No such file: ‘%s’", filename);
            var ft = new FileTags(filename);
            if (artist != null)
                ft.artist = artist;
            if (title != null)
                ft.title = title;
            if (album != null)
                ft.album = album;
            if (composer != null)
                ft.composer = composer;
            if (original != null)
                ft.original = original;
            if (comment != null)
                ft.comment = comment;
            if (s_year != null)
                ft.year = year;
            if (s_track != null && s_total != null) {
                ft.track = track;
                ft.total = total;
            } else if (s_track != null) {
                if (ft.total != -1 && track > ft.total)
                    Util.error(false, ExitCode.INVALID_TRACK, prog_name,
                               "The track cannot be greater than the total");
                ft.track = track;
            } else if (s_total != null) {
                if (ft.track == -1)
                    Util.error(false, ExitCode.INVALID_TRACK, prog_name,
                               "The total cannot be set if the track is not");
                if (total != -1 && ft.track > total)
                    Util.error(false, ExitCode.INVALID_TRACK, prog_name,
                               "The total cannot be less than the track");
                ft.total = total;
            }
            if (s_disc != null)
                ft.disc = disc;
            if (s_genre != null)
                ft.genre = genre;
            if (cover_picture != null)
                ft.cover_picture = cover_picture_data;
            if (artist_picture != null)
                ft.artist_picture = artist_picture_data;
            if (band != null)
                ft.band = band;

            ft.update();
        }

        private static bool edit_file() {
            return (artist != null || title != null || album != null ||
                    band != null || comment != null || composer != null ||
                    original != null || cover_picture != null ||
                    artist_picture != null || s_year != null ||
                    s_track != null || s_total != null ||
                    s_disc != null || s_genre != null);
        }

        private static int parse_int(string s) {
            if (s == "")
                return -1;
            return int.parse(s);
        }

        private static uint8[]? get_picture_data(string picture) {
            uint8[] bytes = null;
            try {
                GLib.FileUtils.get_data(picture, out bytes);
            } catch (GLib.FileError fe) {
                return null;
            }
            return bytes;
        }

        public static int main(string[] args) {
            GLib.Intl.setlocale();
            prog_name = args[0];
            Util.set_locale(GLib.LocaleCategory.NUMERIC);
            try {
                var opt = new GLib.OptionContext(CONTEXT);
                opt.set_help_enabled(true);
                opt.add_main_entries(options, null);
                opt.set_description(DESCRIPTION);
                opt.parse(ref args);
            } catch (GLib.Error e) {
                Util.error(false, ExitCode.INVALID_ARGUMENT, prog_name,
                           e.message);
            }

            DateTime dt = new DateTime.now_local();
            current_year = dt.get_year();

            if (genres)
                print_genres();

            if (args.length < 2)
                Util.error(true, ExitCode.MISSING_FILES, prog_name,
                           "Missing file(s)");

            if (remove) {
                for (int i = 1; i < args.length; i++)
                    remove_tags(args[i]);
                Process.exit(ExitCode.A_OK);
            }

            if (out_cover_picture != null || out_artist_picture != null) {
                if (args.length > 2)
                    Util.error(true, ExitCode.IMAGE_FOR_MANY, prog_name,
                               "Save image requested for more than one file");
                if (out_cover_picture != null)
                    save_picture(args[1], out_cover_picture,
                                 PictureType.COVER);
                else
                    save_picture(args[1], out_artist_picture,
                                 PictureType.ARTIST);
                Process.exit(ExitCode.A_OK);
            }

            if (!edit_file()) {
                for (int i = 1; i < args.length; i++)
                    if (format == null)
                        print_standard_tags(args[i]);
                    else
                        print_tags(args[i], format);
                Process.exit(ExitCode.A_OK);
            }

            if (s_year != null) {
                year = parse_int(s_year);
                if (year != -1 && (year < MIN_YEAR || year > current_year))
                    Util.error(false, ExitCode.INVALID_YEAR, prog_name,
                               "The year ‘%s’ is invalid", s_year);
            }

            if (s_track != null) {
                track = parse_int(s_track);
                if (track != -1 && (track < MIN_TRACK || track > MAX_TRACK))
                    Util.error(false, ExitCode.INVALID_TRACK, prog_name,
                               "The track ‘%s’ is invalid", s_track);
            }

            if (s_total != null) {
                total = parse_int(s_total);
                if (total != -1 && (total < MIN_TRACK || total > MAX_TRACK))
                    Util.error(false, ExitCode.INVALID_TRACK, prog_name,
                               "The total ‘%s’ is invalid", s_total);
            }

            if (s_track != null && s_total != null && track > total)
                Util.error(false, ExitCode.INVALID_TRACK, prog_name,
                           "The track cannot be greater than the total");

            if (s_disc != null) {
                disc = parse_int(s_disc);
                if (disc != -1 && (disc < MIN_DISC || disc > MAX_DISC))
                    Util.error(false, ExitCode.INVALID_DISC, prog_name,
                               "The disc ‘%s’ is invalid", s_disc);
            }

            if (s_genre == "") {
                genre = -1;
            } else if (s_genre != null) {
                genre = Genre.index_of(s_genre);
                if (genre == -1)
                    Util.error(false, ExitCode.INVALID_GENRE, prog_name,
                               "Invalid genre ‘%s’", s_genre);
            }

            if (cover_picture != null && cover_picture != "") {
                var bytes = get_picture_data(cover_picture);
                if (bytes == null)
                    Util.error(false, ExitCode.READING_ERROR, prog_name,
                               "There was an error reading from ‘%s’",
                               cover_picture);
                cover_picture_data = bytes;
            }

            if (artist_picture != null && artist_picture != "") {
                var bytes = get_picture_data(artist_picture);
                if (bytes == null)
                    Util.error(false, ExitCode.READING_ERROR, prog_name,
                               "There was an error reading from ‘%s’",
                               cover_picture);
                artist_picture_data = bytes;
            }

            for (int i = 1; i < args.length; i++)
                update_tags(args[i]);

            return ExitCode.A_OK;
        }
    }
}
