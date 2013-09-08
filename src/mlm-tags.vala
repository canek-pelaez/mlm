using Gee;

extern void exit(int exit_code);

namespace MLM {

    namespace Flags {
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
        private static const string S_OUT_FCP  = "-F";
        private static const string S_OUT_AP   = "-A";
    }

    public class Tags {

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
   -F, --output-front-cover-picture=File name Save the front cover picture in file.
   -A, --output-artist-picure=File name       Save the artist picture in file.

With no flags the standard tags are printed.  An empty string as
parameter removes an individual tag.  You can only use the -F or -A
flags with one MP3 file.

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

        private static void print_standard_tags(string filename) {
            if (!FileUtils.test(filename, FileTest.EXISTS)) {
                stderr.printf("No such file: '%s'\n", filename);
                return;
            }
            stdout.printf("=============== %s\n",
                          Filename.display_basename(filename));
            var file_tags = new FileTags(filename);
            if (!file_tags.has_tags) {
                stderr.printf("The file has no ID3 v2.4.0 tags.\n");
                return;
            }
            Genres[] genres = Genres.all();
            if (file_tags.artist != null)
                stdout.printf("Artist: %s\n", file_tags.artist);
            if (file_tags.title != null)
                stdout.printf("Title: %s\n", file_tags.title);
            if (file_tags.album != null)
                stdout.printf("Album: %s\n", file_tags.album);
            if (file_tags.year != -1)
                stdout.printf("Year: %d\n", file_tags.year);
            if (file_tags.track_number != -1) {
                if (file_tags.track_count != -1)
                    stdout.printf("Track: %d of %d\n",
                                  file_tags.track_number,
                                  file_tags.track_count);
            }
            if (file_tags.disc_number != -1)
                stdout.printf("Disc number: %d\n", file_tags.disc_number);
            if (file_tags.genre != -1)
                stdout.printf("Genre: %s\n", genres[file_tags.genre].to_string());
            if (file_tags.comment != null)
                stdout.printf("Comment: %s\n", file_tags.comment);
            if (file_tags.composer != null)
                stdout.printf("Composer: %s\n", file_tags.composer);
            if (file_tags.original_artist != null)
                stdout.printf("Original artist: %s\n", file_tags.original_artist);
            if (file_tags.front_cover_picture != null)
                stdout.printf("Front cover picture: %s\n", file_tags.front_cover_picture_description);
            if (file_tags.artist_picture != null)
                stdout.printf("Artist picture: %s\n", file_tags.artist_picture_description);
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

            Genres[] g = Genres.all();
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
            if (flags.has_key(Flags.ARTIST))
                ft.update_artist(flags[Flags.ARTIST]);
            if (flags.has_key(Flags.TITLE))
                ft.update_title(flags[Flags.TITLE]);
            if (flags.has_key(Flags.ALBUM))
                ft.update_album(flags[Flags.ALBUM]);
            if (flags.has_key(Flags.COMMENT))
                ft.update_comment(flags[Flags.COMMENT]);
            if (flags.has_key(Flags.ORIGINAL))
                ft.update_original_artist(flags[Flags.ORIGINAL]);
            ft.update();
        }

        public static int main(string[] args) {
            var available_flags = new HashMap<string, string>();
            available_flags[Flags.S_HELP] = Flags.HELP;
            available_flags[Flags.S_ARTIST] = Flags.ARTIST;
            available_flags[Flags.S_TITLE] = Flags.TITLE;
            available_flags[Flags.S_ALBUM] = Flags.ALBUM;
            available_flags[Flags.S_YEAR] = Flags.YEAR;
            available_flags[Flags.S_TRACK_N] = Flags.TRACK_N;
            available_flags[Flags.S_TRACK_C] = Flags.TRACK_C;
            available_flags[Flags.S_DISC_N] = Flags.DISC_N;
            available_flags[Flags.S_GENRE] = Flags.GENRE;
            available_flags[Flags.S_COMMENT] = Flags.COMMENT;
            available_flags[Flags.S_COMPOSER] = Flags.COMPOSER;
            available_flags[Flags.S_ORIGINAL] = Flags.ORIGINAL;
            available_flags[Flags.S_COVER_P] = Flags.COVER_P;
            available_flags[Flags.S_ARTIST_P] = Flags.ARTIST_P;
            available_flags[Flags.S_REMOVE] = Flags.REMOVE;
            available_flags[Flags.S_PRINT] = Flags.PRINT;
            available_flags[Flags.S_OUT_FCP] = Flags.OUT_FCP;
            available_flags[Flags.S_OUT_AP] = Flags.OUT_AP;

            var flags = new HashMap<string, string>();
            var filenames = new ArrayList<string>();

            for (int i = 1; i < args.length; i++) {
                string a = args[i];
                if (args[i].has_prefix("--")) {
                    if (a == Flags.HELP || a == Flags.REMOVE) {
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
                    if (i+1 >= args.length || !available_flags.has_key(a))
                        print_usage(1);
                    flags[available_flags[a]] = args[i+1];
                    i++;
                } else {
                    filenames.add(a);
                }
            }

            /*foreach (var entry in flags.entries) {
              stdout.printf("%s => %s\n", entry.key, entry.value);
              }*/

            if (flags.has_key(Flags.HELP))
                print_usage(0);

            if (filenames.size == 0)
                print_usage(1);

            if (flags.size == 0) {
                foreach (var filename in filenames) {
                    print_standard_tags(filename);
                }
                exit(0);
            }

            if (flags.has_key(Flags.PRINT)) {
                foreach (var filename in filenames)
                print_tags(filename, flags[Flags.PRINT]);
                exit(0);
            }

            if (flags.has_key(Flags.REMOVE)) {
                foreach (var filename in filenames)
                remove_tags(filename);
                exit(0);
            }

            if (flags.has_key(Flags.OUT_FCP) || flags.has_key(Flags.OUT_AP)) {

                if (filenames.size > 1)
                    print_usage(1);

                if (flags.has_key(Flags.OUT_FCP)) {
                    string fc = flags[Flags.OUT_FCP];
                    if (fc == "")
                        print_usage(1);
                    save_picture(filenames[0], fc, true);
                }

                if (flags.has_key(Flags.OUT_AP)) {
                    string art = flags[Flags.OUT_AP];
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
