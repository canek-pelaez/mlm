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

using Gee;

extern void exit(int exit_code);

namespace MLM {

    namespace Flag {
        private static const string HELP     = "--help";
        private static const string ARTIST   = "--artist";
        private static const string TITLE    = "--title";
        private static const string ALBUM    = "--album";
        private static const string YEAR     = "--year";
        private static const string TRACK_N  = "--track-number";
        private static const string TRACK_C  = "--track-count";
        private static const string DISC_N   = "--disc-number";
        private static const string GENRE    = "--genre";
        private static const string COMMENT  = "--comment";
        private static const string COMPOSER = "--composer";
        private static const string ORIGINAL = "--original-artist";
        private static const string COVER_P  = "--front-cover-picture";
        private static const string ARTIST_P = "--artist-picture";
        private static const string REMOVE   = "--remove";
        private static const string PRINT    = "--print";
        private static const string P_GENRES = "--print-genres";
        private static const string OUT_FCP  = "--output-front-cover-picture";
        private static const string OUT_AP   = "--output-artist-picture";

        private static const string S_HELP     = "-h";
        private static const string S_ARTIST   = "-a";
        private static const string S_TITLE    = "-t";
        private static const string S_ALBUM    = "-l";
        private static const string S_YEAR     = "-y";
        private static const string S_TRACK_N  = "-n";
        private static const string S_TRACK_C  = "-#";
        private static const string S_DISC_N   = "-d";
        private static const string S_GENRE    = "-g";
        private static const string S_COMMENT  = "-c";
        private static const string S_COMPOSER = "-s";
        private static const string S_ORIGINAL = "-o";
        private static const string S_COVER_P  = "-f";
        private static const string S_ARTIST_P = "-u";
        private static const string S_REMOVE   = "-r";
        private static const string S_PRINT    = "-p";
        private static const string S_P_GENRES = "-G";
        private static const string S_OUT_FCP  = "-F";
        private static const string S_OUT_AP   = "-A";
    }

    public class Tags {

        private static int current_year;
        private static int output_width = 80;

        private static void print_usage(int exit_status) {
            stderr.printf("Use: mlm-tags [options] mp3file1 [mp3file2 ...]\n\n");
            string usage = """Options:
   -h, --help                                 Print this help.
   -a, --artist='Artist'                      Set the artist.
   -t, --title='Title'                        Set the title.
   -l, --album='Album'                        Set the album.
   -y, --year='Year'                          Set the year.
   -n, --track-number='Track number'          Set the track number.
   -#, --track-count='Track count'            Set the track count.
   -d, --disc-number='Disc number'            Set the disc number.
   -g, --genre='Genre'                        Set the genre.
   -c, --comment='Comment'                    Set the comment.
   -s, --composer='Composer'                  Set the composer.
   -o, --original-artist='Original Artist'    Set the original artist.
   -f, --front-cover-picture=file.jpg         Set the front cover picture from file.
   -u, --artist-picture=file.jpg              Set the artist picture from file.
   -r, --remove                               Remove all tags.
   -p, --print=Format                         Print the tags with format.
   -G, --print-genres                         Print supported genres.
   -F, --output-front-cover-picture=File name Save the front cover picture in file.
   -A, --output-artist-picure=File name       Save the artist picture in file.

With no flags the standard tags are printed. An empty string as parameter
removes an individual tag. You can only use the -F or -A flags with one MP3
file.

Format for printing:

   %a: Artist
   %t: Title
   %l: Album
   %y: Year
   %n: Track number
   %N: Track number (zero padded)
   %#: Track count
   %C: Track count (zero padded)
   %d: Disc number
   %D: Disc number (zero padded)
   %g: Genre
   %c: Comment
   %s: Composer
   %o: Original artist
""";
            stderr.printf(usage);
            exit(exit_status);
        }

        private static void print_genres() {
            Genre[] genres = Genre.all();
            stdout.printf("Supported genres:\n");
            for (int i = 0; i < genres.length; i++)
                stdout.printf("   %s %s\n",
                              ConsoleTools.blue("%03d".printf(i)),
                              ConsoleTools.yellow(genres[i].to_string()));
            exit(0);
        }

        private static uint char_count(string s) {
            string t = s.replace("\033[1m\033", "");
            t = t.replace("\033[0m", "");
            for (int i = 90; i <= 96; i++) {
                string r = "[%dm".printf(i);
                t = t.replace(r, "");
            }
            return t.char_count();
        }

        private static ArrayList<string> split_line(string line) {
            var ll = new ArrayList<string>();
            string[] words = line.split(" ");
            string l = words[0];
            for (int i = 1; i < words.length; i++) {
                if (char_count(l) + 1 + char_count(words[i]) < output_width - 2) {
                    l += " " + words[i];
                } else {
                    ll.add(l);
                    l = "    " + words[i];
                }
            }
            ll.add(l);
            return ll;
        }

        private static string boxed_output(ArrayList<string> lines) {
            string output = "┏";
            for (int i = 0; i < output_width - 2; i++)
                output += "━";
            output += "┓";
            output = ConsoleTools.red(output) + "\n";

            int c = 0;
            foreach (var line in lines) {
                int cc = 0;
                var ll = split_line(line);
                foreach (var l in ll) {
                    int ac = (cc == 0 && c > 0) ? 26 : 13;
                    if (ll.size > 1 && cc > 0)
                        ac = 7;
                    output += ConsoleTools.red("┃");
                    if (ll.size > 1) {
                        output += ConsoleTools.yellow(l);
                        if (cc++ == 0)
                            ac = 22;
                        else
                            ac = 4;
                    } else {
                        output += l;
                    }
                    for (int i = 0; i < output_width - l.char_count() - 2 + ac; i++)
                        output += " ";
                    output += ConsoleTools.red("┃") + "\n";
                }
                if (c++ == 0) {
                    output += ConsoleTools.red("┠");
                    for (int i = 0; i < output_width - 2; i++)
                        output += ConsoleTools.red("─");
                    output += ConsoleTools.red("┨") + "\n";
                }
            }

            string last_line = "┗";
            for (int i = 0; i < output_width - 2; i++)
                last_line += "━";
            last_line += "┛";

            output += ConsoleTools.red(last_line) + "\n";

            return output;
        }

        private static void print_standard_tags(string filename) {
            if (!FileUtils.test(filename, FileTest.EXISTS)) {
                stderr.printf("No such file: '%s'\n", filename);
                return;
            }
            var file_tags = new FileTags(filename);
            if (!file_tags.has_tags) {
                stderr.printf("The file '%s' has no ID3 v2.4.0 tags.\n", filename);
                return;
            }
            var lines = new ArrayList<string>();
            string line = ConsoleTools.cyan(Filename.display_basename(filename));
            lines.add(line);
            Genre[] genres = Genre.all();
            if (file_tags.artist != null)
                lines.add(ConsoleTools.key_value("Artist", file_tags.artist));
            if (file_tags.title != null)
                lines.add(ConsoleTools.key_value("Title", file_tags.title));
            if (file_tags.album != null)
                lines.add(ConsoleTools.key_value("Album", file_tags.album));
            if (file_tags.year != -1)
                lines.add(ConsoleTools.key_value("Year", "%d".printf(file_tags.year)));
            if (file_tags.track_number != -1) {
                if (file_tags.track_count != -1)
                    lines.add(
                        ConsoleTools.key_value(
                            "Track",
                            "%d of %d".printf(file_tags.track_number,
                                              file_tags.track_count)));
                else
                    lines.add(
                        ConsoleTools.key_value(
                            "Track",
                            "%d".printf(file_tags.track_number)));
            }
            if (file_tags.disc_number != -1)
                lines.add(ConsoleTools.key_value("Disc number",
                                                 "%d".printf(file_tags.disc_number)));
            if (file_tags.genre != -1)
                lines.add(ConsoleTools.key_value("Genre",
                                                 genres[file_tags.genre].to_string()));
            if (file_tags.comment != null)
                lines.add(ConsoleTools.key_value("Comment",
                                                 file_tags.comment));
            if (file_tags.composer != null)
                lines.add(ConsoleTools.key_value("Composer",
                                                 file_tags.composer));
            if (file_tags.original_artist != null)
                lines.add(ConsoleTools.key_value("Original artist",
                                                 file_tags.original_artist));
            if (file_tags.front_cover_picture != null)
                lines.add(ConsoleTools.key_value("Front cover picture",
                                                 file_tags.front_cover_picture_description));
            if (file_tags.artist_picture != null)
                lines.add(ConsoleTools.key_value("Artist picture",
                                                 file_tags.artist_picture_description));
            stdout.printf("%s", boxed_output(lines));
        }

        private static void print_tags(string filename, string format) {
            if (!FileUtils.test(filename, FileTest.EXISTS)) {
                stderr.printf("No such file: '%s'\n", filename);
                return;
            }
            var ft = new FileTags(filename);
            if (!ft.has_tags) {
                stderr.printf("The file '%s' has no ID3 v2.4.0 tags.\n",
                              filename);
                return;
            }

            Genre[] g = Genre.all();
            string f = format;

            f = f.replace("\\n", "\n");
            f = f.replace("\\t", "\t");
            if (ft.artist != null);
            f = f.replace("%a", ft.artist);
            if (ft.title != null)
                f = f.replace("%t", ft.title);
            if (ft.album != null)
                f = f.replace("%l", ft.album);
            if (ft.year != -1)
                f = f.replace("%y", "%d".printf(ft.year));
            if (ft.track_number != -1) {
                f = f.replace("%n", "%d".printf(ft.track_number));
                f = f.replace("%N", "%02d".printf(ft.track_number));
            }
            if (ft.track_count != -1) {
                f = f.replace("%#", "%d".printf(ft.track_count));
                f = f.replace("%C", "%02d".printf(ft.track_count));
            }
            if (ft.disc_number != -1) {
                f = f.replace("%d", "%d".printf(ft.disc_number));
                f = f.replace("%D", "%02d".printf(ft.disc_number));
            }
            if (ft.genre != -1)
                f = f.replace("%g", g[ft.genre].to_string());
            if (ft.comment != null)
                f = f.replace("%c", ft.comment);
            if (ft.composer != null)
                f = f.replace("%s", ft.composer);
            if (ft.original_artist != null)
                f = f.replace("%o", ft.original_artist);

            stdout.printf(f);
        }

        private static void remove_tags(string filename) {
            stderr.printf("Removing tags from '%s'...\n", filename);
            if (!FileUtils.test(filename, FileTest.EXISTS)) {
                stderr.printf("No such file: '%s'\n", filename);
                return;
            }
            var ft = new FileTags(filename);
            if (!ft.has_tags) {
                stderr.printf("The file '%s' has no ID3 v2.4.0 tags.\n",
                              filename);
                return;
            }
            ft.remove_tags();
        }

        private static void save_picture(string filename,
                                         string picture_filename,
                                         bool   front_cover) {
            if (!FileUtils.test(filename, FileTest.EXISTS)) {
                stderr.printf("No such file: '%s'\n", filename);
                return;
            }
            if (!picture_filename.has_suffix(".jpg")) {
                stderr.printf("The file '%s' doesn't have a '.jpg' extension.\n",
                              picture_filename);
                return;
            }
            var file_tags = new FileTags(filename);
            if (!file_tags.has_tags) {
                stderr.printf("The file '%s' has no ID3 v2.4.0 tags.\n",
                              filename);
                return;
            }
            unowned uint8[] data = file_tags.front_cover_picture;
            string type = "front cover";
            if (!front_cover) {
                data = file_tags.artist_picture;
                type = "artist";
            }
            if (data == null) {
                stderr.printf("The file '%s' has no %s picture.\n", filename, type);
                return;
            }
            FileStream file = FileStream.open(picture_filename, "w");
            if (file == null) {
                stderr.printf("There was an error writing to '%s'.\n",
                              picture_filename);
                return;
            }
            file.write(data);
        }

        private static void update_tags(string filename, HashMap<string, string> flags) {
            if (!FileUtils.test(filename, FileTest.EXISTS)) {
                stderr.printf("No such file: '%s'\n", filename);
                return;
            }
            var ft = new FileTags(filename);
            if (flags.has_key(Flag.ARTIST))
                ft.update_artist(flags[Flag.ARTIST]);
            if (flags.has_key(Flag.TITLE))
                ft.update_title(flags[Flag.TITLE]);
            if (flags.has_key(Flag.ALBUM))
                ft.update_album(flags[Flag.ALBUM]);
            if (flags.has_key(Flag.COMPOSER))
                ft.update_composer(flags[Flag.COMPOSER]);
            if (flags.has_key(Flag.ORIGINAL))
                ft.update_original_artist(flags[Flag.ORIGINAL]);
            if (flags.has_key(Flag.COMMENT))
                ft.update_comment(flags[Flag.COMMENT]);
            if (flags.has_key(Flag.YEAR)) {
                if (flags[Flag.YEAR] == "") {
                    ft.update_year(-1);
                } else {
                    int year = int.parse(flags[Flag.YEAR]);
                    if (year >= 1900 && year <= current_year)
                        ft.update_year(year);
                    else
                        stderr.printf("The year %d is invalid. Ignoring.\n", year);
                }
            }
            if (flags.has_key(Flag.DISC_N)) {
                if (flags[Flag.DISC_N] == "") {
                    ft.update_disc_number(-1);
                } else {
                    int dn = int.parse(flags[Flag.DISC_N]);
                    if (dn >= 1 && dn <= 99)
                        ft.update_disc_number(dn);
                    else
                        stderr.printf("The disc number %d is invalid. Ignoring.\n", dn);
                }
            }
            if (flags.has_key(Flag.TRACK_N) || flags.has_key(Flag.TRACK_C)) {
                int tn = ft.track_number;
                int tc = ft.track_count;
                if (flags.has_key(Flag.TRACK_N) && flags[Flag.TRACK_N] == "")
                    tn = -1;
                else if (flags.has_key(Flag.TRACK_N))
                    tn = int.parse(flags[Flag.TRACK_N]);
                if (flags.has_key(Flag.TRACK_C) && flags[Flag.TRACK_C] == "")
                    tc = -1;
                else if (flags.has_key(Flag.TRACK_C))
                    tc = int.parse(flags[Flag.TRACK_C]);
                if ((tn == -1 && tc == -1)            ||
                    (tn >= 1 && tn <= 99 && tc == -1) ||
                    (tn >= 1 && tn <= 99 && tc >= 1 && tc <= 99)) {
                    ft.update_track(tn, tc);
                } else if (tc >= 1 && tc <= 99 && tn == -1) {
                    stderr.printf("You cannot set the track count while the " +
                                  "track number is unset. Ignoring tracks.\n");
                } else {
                    stderr.printf("Invalid combination of track number/track "+
                                  "count. Ignoring tracks.\n");
                }
            }
            if (flags.has_key(Flag.GENRE)) {
                int new_genre = -1;
                Genre[] genres = Genre.all();
                string genre = flags[Flag.GENRE];
                for (int i = 0; i < genres.length; i++)
                    if (genre.ascii_casecmp(genres[i].to_string()) == 0)
                        new_genre = i;
                if (new_genre == -1) {
                    int64 ng;
                    if (int64.try_parse(genre, out ng)) {
                        new_genre = (int)ng;
                        if (new_genre < 0 || new_genre >= genres.length)
                            new_genre = -1;
                    } else {
                        new_genre = -1;
                    }
                }
                if (new_genre != -1)
                    ft.update_genre(new_genre);
                else
                    stderr.printf("The genre '%s' is invalid. Ignoring.\n", genre);
            }
            if (flags.has_key(Flag.COVER_P)) {
                if (flags[Flag.COVER_P] == "") {
                    ft.update_front_cover_picture(null);
                } else {
                    uint8[] bytes = null;
                    try {
                        FileUtils.get_data(flags[Flag.COVER_P], out bytes);
                    } catch (FileError fe) {
                        stderr.printf("There was an error reading from '%s'. Ignoring.\n", filename);
                        bytes = null;
                    }
                    if (bytes != null)
                        ft.update_front_cover_picture(bytes);
                }
            }
            if (flags.has_key(Flag.ARTIST_P)) {
                if (flags[Flag.ARTIST_P] == "") {
                    ft.update_artist_picture(null);
                } else {
                    uint8[] bytes = null;
                    try {
                        FileUtils.get_data(flags[Flag.ARTIST_P], out bytes);
                    } catch (FileError fe) {
                        stderr.printf("There was an error reading from '%s'. Ignoring.\n", filename);
                        bytes = null;
                    }
                    if (bytes != null)
                        ft.update_artist_picture(bytes);
                }
            }

            ft.update();
        }

        public static int main(string[] args) {
            DateTime dt = new DateTime.now_local();
            current_year = dt.get_year();

            var available_flags = new HashMap<string, string>();
            available_flags[Flag.S_HELP] = Flag.HELP;
            available_flags[Flag.S_ARTIST] = Flag.ARTIST;
            available_flags[Flag.S_TITLE] = Flag.TITLE;
            available_flags[Flag.S_ALBUM] = Flag.ALBUM;
            available_flags[Flag.S_YEAR] = Flag.YEAR;
            available_flags[Flag.S_TRACK_N] = Flag.TRACK_N;
            available_flags[Flag.S_TRACK_C] = Flag.TRACK_C;
            available_flags[Flag.S_DISC_N] = Flag.DISC_N;
            available_flags[Flag.S_GENRE] = Flag.GENRE;
            available_flags[Flag.S_COMMENT] = Flag.COMMENT;
            available_flags[Flag.S_COMPOSER] = Flag.COMPOSER;
            available_flags[Flag.S_ORIGINAL] = Flag.ORIGINAL;
            available_flags[Flag.S_COVER_P] = Flag.COVER_P;
            available_flags[Flag.S_ARTIST_P] = Flag.ARTIST_P;
            available_flags[Flag.S_REMOVE] = Flag.REMOVE;
            available_flags[Flag.S_PRINT] = Flag.PRINT;
            available_flags[Flag.S_P_GENRES] = Flag.P_GENRES;
            available_flags[Flag.S_OUT_FCP] = Flag.OUT_FCP;
            available_flags[Flag.S_OUT_AP] = Flag.OUT_AP;

            var flags = new HashMap<string, string>();
            var filenames = new ArrayList<string>();

            for (int i = 1; i < args.length; i++) {
                string a = args[i];
                if (args[i].has_prefix("--")) {
                    if (a == Flag.HELP || a == Flag.REMOVE || a == Flag.P_GENRES) {
                        flags[a] = "";
                    } else {
                        int idx = a.index_of("=");
                        if (idx == -1)
                            print_usage(1);
                        string[] t = a.split("=");
                        if (t.length != 2 || !(t[0] in available_flags.values))
                            print_usage(1);
                        flags[t[0]] = t[1];
                    }
                } else if (a.has_prefix("-")) {
                    if (a == Flag.S_HELP || a == Flag.S_REMOVE || a == Flag.S_P_GENRES) {
                        flags[available_flags[a]] = "";
                    } else if (i+1 >= args.length || !available_flags.has_key(a)) {
                        print_usage(1);
                    } else {
                        flags[available_flags[a]] = args[i+1];
                        i++;
                    }
                } else {
                    filenames.add(a);
                }
            }

            if (flags.has_key(Flag.HELP))
                print_usage(0);

            if (flags.has_key(Flag.P_GENRES))
                print_genres();

            if (filenames.size == 0)
                print_usage(1);

            if (flags.size == 0) {
                foreach (var filename in filenames) {
                    print_standard_tags(filename);
                }
                exit(0);
            }

            if (flags.has_key(Flag.PRINT)) {
                foreach (var filename in filenames) {
                    print_tags(filename, flags[Flag.PRINT]);
                }
                exit(0);
            }

            if (flags.has_key(Flag.REMOVE)) {
                foreach (var filename in filenames) {
                    remove_tags(filename);
                }
                exit(0);
            }

            if (flags.has_key(Flag.OUT_FCP) || flags.has_key(Flag.OUT_AP)) {

                if (filenames.size > 1)
                    print_usage(1);

                if (flags.has_key(Flag.OUT_FCP)) {
                    string fc = flags[Flag.OUT_FCP];
                    if (fc == "")
                        print_usage(1);
                    save_picture(filenames[0], fc, true);
                }

                if (flags.has_key(Flag.OUT_AP)) {
                    string art = flags[Flag.OUT_AP];
                    if (art == "")
                        print_usage(1);
                    save_picture(filenames[0], art, false);
                }

                exit(0);
            }

            foreach (var filename in filenames)
                update_tags(filename, flags);

            return 0;
        }
    }
}
