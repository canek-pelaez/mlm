/*
 * This file is part of mlm.
 *
 * Copyright 2013-2014 Canek Peláez Valdés
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

namespace MLM {

    public class Accommodator {

        private enum ReturnCode {
            OK                  = 0,
            INVALID_ARGUMENT    = 1,
            MISSING_OUTPUT_DIR  = 2,
            MISSING_FILES       = 3,
            INVALID_OUTPUT_DIR  = 4,
            INVALID_DESTINATION = 5,
            NOT_ENOUGH_INFO     = 6,
            COPY_ERROR          = 7
        }

        private static string directory;

        private const GLib.OptionEntry[] options = {
            { "output", 'o', 0, GLib.OptionArg.FILENAME, ref directory,
              "Output directory", "DIRECTORY" },
            { null }
        };

        private string filename;
        private string artist;
        private string title;
        private string album;
        private string band;
        private int disc = -1;
        private int track = -1;

        public Accommodator(string filename) {
            this.filename = filename;
            var tags = new FileTags(filename);
            if (tags.artist != null)
                artist = Util.asciize(tags.artist);
            if (tags.title != null)
                title = Util.asciize(tags.title);
            if (tags.album != null)
                album = Util.asciize(tags.album);
            if (tags.band != null)
                band = Util.asciize(tags.band);
            else
                band = artist;
            disc = tags.disc;
            track = tags.track;
        }

        public int accommodate() {
            if (artist == null || title == null || album == null)
                return error("Not enough information to accomodate ‘%s’".printf(filename),
                             ReturnCode.NOT_ENOUGH_INFO);
            var letter = band.get_char(0).to_string();

            string[] subdirs = { letter, band, album };
            var dir = directory;
            foreach (var subdir in subdirs) {
                dir = dir + Path.DIR_SEPARATOR_S + subdir;
                if (!GLib.FileUtils.test(dir, GLib.FileTest.EXISTS)) {
                    GLib.DirUtils.create(dir, 0755);
                } else if (!GLib.FileUtils.test(dir, GLib.FileTest.IS_DIR)) {
                    return error("Invalid destination",
                                 ReturnCode.INVALID_DESTINATION);
                }
            }

            string dest = "";

            if (disc != -1 && track != -1)
                dest = "%s/%d_-_%02d_-_%s_-_%s.mp3".printf(dir, disc, track, artist, title);
            else
                dest = "%s/%s_-_%s.mp3".printf(dir, artist, title);

            var src = GLib.File.new_for_path(filename);
            var dst = GLib.File.new_for_path(dest);
            try {
                var time = Util.get_file_time(filename);
                src.copy(dst, GLib.FileCopyFlags.OVERWRITE);
                Util.set_file_time(dest, time);
            } catch (GLib.Error e) {
                return error(e.message, ReturnCode.COPY_ERROR);
            }
            stdout.printf("Copied\t‘%s’\ninto\t‘%s’\n",
                          Util.color(src.get_basename(), Color.RED),
                          Util.color(dst.get_basename(), Color.GREEN));
            return 0;
        }

        private static int error(string error,
                                 int    return_code,
                                 string command = "mlm-accommodator",
                                 bool   help = false) {
            stderr.printf("error: %s\n", error);
            if (help)
                stderr.printf("Run ‘%s --help’ for a list of options.\n".printf(command));
            return return_code;
        }

        public static int main(string[] args) {
            try {
                var opt = new GLib.OptionContext("FILE... - Accommodate MP3 files");
                opt.set_help_enabled(true);
                opt.add_main_entries(options, null);
                opt.parse(ref args);
            } catch (GLib.OptionError e) {
                return error(e.message, ReturnCode.INVALID_ARGUMENT);
            }

            if (directory == null)
                return error("Missing output directory",
                             ReturnCode.MISSING_OUTPUT_DIR,
                             args[0], true);

            if (args.length < 2)
                return error("Missing MP3 file(s)",
                             ReturnCode.MISSING_FILES,
                             args[0], true);

            if (GLib.FileUtils.test(directory, GLib.FileTest.EXISTS) &&
                !GLib.FileUtils.test(directory, GLib.FileTest.IS_DIR))
                return error("Invalid output directory",
                             ReturnCode.INVALID_OUTPUT_DIR,
                             args[0], true);

            if (!GLib.FileUtils.test(directory, GLib.FileTest.EXISTS))
                GLib.DirUtils.create(directory, 0755);

            for (int i = 1; i < args.length; i++) {
                var accommodator = new Accommodator(args[i]);
                int r = accommodator.accommodate();
                if (r != ReturnCode.OK)
                    return r;
            }

            return ReturnCode.OK;
        }
    }
}
