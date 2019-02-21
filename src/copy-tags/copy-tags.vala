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

    public class CopyTags {

        private string source;
        private string target;
        private FileTags source_tags;
        private FileTags target_tags;

        public CopyTags(string source, string target) {
            this.source = source;
            this.source_tags = new FileTags(source);
            this.target = target;
            this.target_tags = new FileTags(target);
        }

        public void copy() {
            var time = Util.get_file_time(source);
            target_tags.copy(source_tags);
            target_tags.update();
            target_tags = null;
            Util.set_file_time(target, time);
        }

        private const string CONTEXT =
            "SOURCE TARGET - Copy Id3v2.4.0 standard tags";

        private const string DESCRIPTION =
            "The SOURCE and TARGET MP3 files need to exist.\n";

        public static int main(string[] args) {
            try {
                var opt = new GLib.OptionContext(CONTEXT);
                opt.set_help_enabled(true);
                opt.set_description(DESCRIPTION);
                opt.parse(ref args);
            } catch (GLib.OptionError e) {
                Util.error(true, ExitCode.INVALID_ARGUMENT, args[0],
                           e.message);
            }

            if (args.length != 3)
                Util.error(true, ExitCode.MISSING_ARGUMENT, args[0],
                           "Missing SOURCE and/or TARGET MP3 files");

            string source = args[1];
            string target = args[2];

            if (!FileUtils.test(source, FileTest.EXISTS))
                Util.error(false, ExitCode.NO_SUCH_FILE, args[0],
                           "The source file ‘%s’ does not exists.",
                           source);

            if (!FileUtils.test(target, FileTest.EXISTS))
                Util.error(false, ExitCode.NO_SUCH_FILE, args[0],
                           "The target file ‘%s’ does not exists.",
                           target);

            var ct = new CopyTags(source, target);
            ct.copy();

            return ExitCode.A_OK;
        }
    }
}
