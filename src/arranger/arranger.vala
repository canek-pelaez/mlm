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
     * Class for arrangers.
     */
    public class Arranger {

        /* Exit codes enumeration. */
        private enum ExitCode {
            OK,
            INVALID_ARGUMENT,
            MISSING_OUTPUT_DIR,
            MISSING_FILES,
            INVALID_OUTPUT_DIR,
            INVALID_DESTINATION,
            NOT_ENOUGH_INFO,
            COPY_ERROR,
            NO_SUCH_FILE;
        }

        /* The directory where to arrange the files. */
        private static string directory;
        /* The command. */
        private static string command;

        /* The program options. */
        private const GLib.OptionEntry[] options = {
            { "output", 'o', 0, GLib.OptionArg.FILENAME, ref directory,
              "Output directory", "DIRECTORY" },
            { null }
        };

        /* The filename. */
        private string filename;
        /* The artist. */
        private string artist;
        /* The title. */
        private string title;
        /* The album. */
        private string album;
        /* The band. */
        private string band;
        /* The disc. */
        /* The track. */
        private int disc = -1;
        private int track = -1;

        /**
         * Initializes an arranger.
         * @param filename the filename.
         */
        public Arranger(string filename) {
            if (!FileUtils.test(filename, FileTest.EXISTS))
                Util.error(false, ExitCode.NO_SUCH_FILE, command,
                           "The file ‘%s’ does not exist.", filename);
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

        /**
         * Arranges the file.
         */
        public void arrange() {
            if (artist == null || title == null || album == null)
                Util.error(false, ExitCode.NOT_ENOUGH_INFO, command,
                           "Not enough information to arrange ‘%s’",
                           filename);
            var letter = band.get_char(0).to_string();

            string[] subdirs = { letter, band, album };
            var dir = directory;
            foreach (var subdir in subdirs) {
                dir = dir + Path.DIR_SEPARATOR_S + subdir;
                if (!GLib.FileUtils.test(dir, GLib.FileTest.EXISTS)) {
                    GLib.DirUtils.create(dir, 0755);
                } else if (!GLib.FileUtils.test(dir, GLib.FileTest.IS_DIR)) {
                    Util.error(false, ExitCode.INVALID_DESTINATION, command,
                               "Invalid destination");
                }
            }

            string dest = "";

            if (disc != -1 && track != -1)
                dest = "%s/%d_-_%02d_-_%s_-_%s.mp3".printf(dir, disc, track,
                                                           artist, title);
            else
                dest = "%s/%s_-_%s.mp3".printf(dir, artist, title);

            var src = GLib.File.new_for_path(filename);
            var dst = GLib.File.new_for_path(dest);
            try {
                var time = Util.get_file_time(filename);
                src.copy(dst, GLib.FileCopyFlags.OVERWRITE);
                Util.set_file_time(dest, time);
            } catch (GLib.Error e) {
                Util.error(false, ExitCode.COPY_ERROR, command, e.message);
            }
            stdout.printf("Copied\t‘%s’\ninto\t‘%s’\n",
                          Util.color(src.get_basename(), Color.RED),
                          Util.color(dst.get_basename(), Color.GREEN));
        }

        /* The context. */
        private const string CONTEXT =
            "[FILENAME...] - Arranges MP3 files";

        public static int main(string[] args) {
            command = args[0];
            try {
                var opt = new GLib.OptionContext(CONTEXT);
                opt.set_help_enabled(true);
                opt.add_main_entries(options, null);
                opt.parse(ref args);
            } catch (GLib.OptionError e) {
                Util.error(true, ExitCode.INVALID_ARGUMENT, command,
                           e.message);
            }

            if (directory == null)
                Util.error(true, ExitCode.MISSING_OUTPUT_DIR, command,
                           "Missing output directory");

            if (args.length < 2)
                Util.error(true, ExitCode.MISSING_FILES, command,
                    "Missing MP3 file(s)");

            if (GLib.FileUtils.test(directory, GLib.FileTest.EXISTS) &&
                !GLib.FileUtils.test(directory, GLib.FileTest.IS_DIR))
                Util.error(true, ExitCode.INVALID_OUTPUT_DIR, command,
                           "Invalid output directory: %s", directory);

            if (!GLib.FileUtils.test(directory, GLib.FileTest.EXISTS))
                GLib.DirUtils.create(directory, 0755);

            for (int i = 1; i < args.length; i++) {
                if (!GLib.FileUtils.test(args[i], GLib.FileTest.EXISTS)) {
                    stderr.printf("The file “%s” does not exists. Skipping.",
                                  command);
                    continue;
                }
                var arranger = new Arranger(args[i]);
                arranger.arrange();
            }

            return ExitCode.OK;
        }
    }
}
