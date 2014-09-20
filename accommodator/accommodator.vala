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

extern void exit(int exit_code);

namespace MLM {

    public class Accommodator {

        private string filename;
        private string artist;
        private string album;
        private string title;
        private int disc;
        private int track;

        public Accommodator(string filename) {
            this.filename = filename;
            var tags = new FileTags(filename);
            artist = Util.asciize(tags.artist);
            album = Util.asciize(tags.album);
            title = Util.asciize(tags.title);
            disc = tags.disc;
            track = tags.track;
        }

        public void accommodate() {
            var letter = artist.get_char(0).to_string();

            string[] subdirs = { letter, artist, album };
            var dir = directory;
            foreach (var subdir in subdirs) {
                dir = dir + Path.DIR_SEPARATOR_S + subdir;
                if (!GLib.FileUtils.test(dir, GLib.FileTest.EXISTS)) {
                    GLib.DirUtils.create(dir, 0755);
                } else if (!GLib.FileUtils.test(dir, GLib.FileTest.IS_DIR)) {
                    error("Invalid destination");
                }
            }

            var dest = "%s/%d_-_%02d_-_%s_-_%s.mp3".printf(dir, disc, track, artist, title);

            var src = GLib.File.new_for_path(filename);
            var dst = GLib.File.new_for_path(dest);
            try {
                src.copy(dst, GLib.FileCopyFlags.OVERWRITE);
            } catch (GLib.Error e) {
                error(e.message);
            }
            stdout.printf("Copied\t'%s'\ninto\t'%s'\n",
                          Util.term_red(src.get_basename()),
                          Util.term_green(dst.get_basename()));
        }

        private static string directory;

        private const GLib.OptionEntry[] options = {
            { "output", 'o', 0, GLib.OptionArg.FILENAME, ref directory,
              "Output directory", "DIRECTORY" },
            { null }
        };

        private static void error(string error) {
            stdout.printf("error: %s\n".printf(error));
            exit(1);
        }

        private static void print_help(string command, string error) {
            stdout.printf("error: %s\n", error);
            stdout.printf("Run '%s --help' to see a full list ".printf(command) +
                          "of available command line options.\n");
            exit(1);
        }

        public static void main(string[] args) {
            try {
                var opt = new GLib.OptionContext("FILENAMES - MLM accommodator");
                opt.set_help_enabled(true);
                opt.add_main_entries(options, null);
                opt.parse(ref args);
            } catch (GLib.OptionError e) {
                print_help(args[0], e.message);
            }

            if (directory == null)
                print_help(args[0], "Missing output directory");

            if (!GLib.FileUtils.test(directory, GLib.FileTest.EXISTS) ||
                !GLib.FileUtils.test(directory, GLib.FileTest.IS_DIR))
                print_help(args[0], "Invalid output directory");

            foreach (var arg in args[1:args.length]) {
                var accommodator = new Accommodator(arg);
                accommodator.accommodate();
            }
        }
    }
}
