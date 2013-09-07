using Gee;

extern void exit(int exit_code);

namespace MLM {

    public static HashMap<string, string> available_flags;

    public static void print_usage(int exit_status) {
        stderr.printf("Use: mlm-tags [options] mp3file1 [mp3file2 ...]\n\n");
        string usage = """Options:
   -h, --help                                Print this help.
   -a, --artist='Artist'                     Set the artist.
   -t, --title='Title'                       Set the title.
   -l, --album='Album'                       Set the album.
   -y, --year='Year'                         Set the year.
   -n, --track-number='Track number'         Set the track number.
   -#, --track-count='Track count'           Set the track count.
   -d, --disc-number='Disc number'           Set the disc number.
   -g, --genre='Genre'                       Set the genre.
   -c, --comment='Comment'                   Set the comment.
   -s, --composer='Composer'                 Set the composer.
   -o, --original-artist='Original Artist'   Set the original artist.
   -f, --front-cover-image=file.jpg          Set the front cover from file.
   -i, --artist-image=file.jpg               Set the artist image from file.
   -r, --remove                              Remove all tags.
   -p, --print=Format                        Print the tags with format.
   -F, --output-front-cover-image=File name  Save the front cover in file.
   -A, --output-artist-image=File name       Save the artist image in file.

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

    public static void print_standard_tags(string filename) {
        stderr.printf("print_standard_tags\n");
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
            stdout.printf("Picture: Front cover\n");
        if (file_tags.artist_picture != null)
            stdout.printf("Picture: Artist\n");
    }

    public static void print_tags(string filename, string format) {
        stderr.printf("print_tags\n");
    }

    public static void remove_tags(string filename) {
        stderr.printf("remove_tags\n");
    }

    public static void save_front_cover(string filename, string image_filename) {
        stderr.printf("save_front_cover\n");
        var file_tags = new FileTags(filename);
        if (!file_tags.has_tags) {
            stderr.printf("The file '%s' has no ID3 v2.4.0 tags.\n",
                          filename);
            return;
        }
        if (file_tags.front_cover_picture == null) {
            stderr.printf("The file '%s' has no front cover picture.\n",
                          filename);
            return;
        }
        FileStream file = FileStream.open(image_filename, "w");
        if (file == null) {
            stderr.printf("There was an error writing to '%s'.\n",
                          image_filename);
            return;
        }
        file.write(file_tags.front_cover_picture);
    }

    public static void save_artist(string filename, string image_filename) {
        stderr.printf("save_artist\n");
    }

    public static void update_tags(string filename) {
        stderr.printf("update_tags\n");
    }

    public static int main(string[] args) {
        available_flags = new HashMap<string, string>();
        available_flags["-h"] = "--help";
        available_flags["-a"] = "--artist";
        available_flags["-t"] = "--title";
        available_flags["-l"] = "--album";
        available_flags["-y"] = "--year";
        available_flags["-n"] = "--track-number";
        available_flags["-#"] = "--track-count";
        available_flags["-d"] = "--disc-number";
        available_flags["-g"] = "--genre";
        available_flags["-c"] = "--comment";
        available_flags["-s"] = "--composer";
        available_flags["-o"] = "--original-artist";
        available_flags["-f"] = "--front-cover-image";
        available_flags["-i"] = "--artist-image";
        available_flags["-r"] = "--remove";
        available_flags["-p"] = "--print";
        available_flags["-F"] = "--output-front-cover-image";
        available_flags["-A"] = "--output-artist-image";

        var flags = new HashMap<string, string>();
        var filenames = new ArrayList<string>();

        for (int i = 1; i < args.length; i++) {
            string a = args[i];
            if (args[i].has_prefix("--")) {
                if (a == "--help") {
                    flags["-h"] = "";
                } else if (a == "--remove") {
                    flags["-r"] = "";
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

        if (flags.has_key("--help"))
            print_usage(0);

        if (filenames.size == 0)
            print_usage(1);

        if (flags.size == 0) {
            foreach (var filename in filenames) {
                print_standard_tags(filename);
            }
            exit(0);
        }

        if (flags.has_key("--print")) {
            foreach (var filename in filenames)
            print_tags(filename, flags["--print"]);
            exit(0);
        }

        if (flags.has_key("--remove")) {
            foreach (var filename in filenames)
                remove_tags(filename);
            exit(0);
        }

        if (flags.has_key("--output-front-cover-image")) {
            string fc = flags["--output-front-cover-image"];
            if (filenames.size > 1 || fc == "")
                print_usage(1);
            save_front_cover(filenames[0], fc);
            exit(0);
        }

        if (flags.has_key("--output-artist-image")) {
            string art = flags["--output-artist-image"];
            if (filenames.size > 1 || art == "")
                print_usage(1);
            save_artist(filenames[0], art);
            exit(0);
        }

        foreach (var filename in filenames)
            update_tags(filename);

        return 0;
    }
}
