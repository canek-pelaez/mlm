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

        /* The tags. */
        FileTags tags;
        /* The source. */
        private string source;

        /**
         * Initializes an arranger.
         * @param source the source.
         */
        public Arranger(string source) {
            if (!FileUtils.test(source, FileTest.EXISTS))
                Util.error(false, ExitCode.NO_SUCH_FILE, command,
                           "The file ‘%s’ does not exist.", source);
            this.source = source;
            tags = new FileTags(source);
        }

        /**
         * Arranges the file.
         */
        public void arrange() {
            var target = string.join(GLib.Path.DIR_SEPARATOR_S, directory,
                                     Util.normal_form(tags));
            if (target == null)
                Util.error(false, ExitCode.NOT_ENOUGH_INFO, command,
                           "Not enough information to arrange ‘%s’",
                           source);
            var dirname = GLib.Path.get_dirname(target);
            if (GLib.DirUtils.create_with_parents(dirname, 0755) < 0)
                Util.error(false, ExitCode.INVALID_OUTPUT_DIR, command,
                           "Invalid output directory: ‘%s’",
                           dirname);

            var source_file = GLib.File.new_for_path(source);
            var target_file = GLib.File.new_for_path(target);
            try {
                var time = Util.get_file_time(source);
                source_file.copy(target_file, GLib.FileCopyFlags.OVERWRITE);
                Util.set_file_time(target, time);
            } catch (GLib.Error e) {
                Util.error(false, ExitCode.COPY_ERROR, command, e.message);
            }
            stdout.printf("Copied\t‘%s’\ninto\t‘%s’\n",
                          Util.color(source_file.get_basename(), Color.RED),
                          Util.color(target_file.get_basename(), Color.GREEN));
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

            return ExitCode.A_OK;
        }
    }
}
