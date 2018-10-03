/* test-path-main.vala - This file is part of mlm.
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
 * this program. If not, see <http://www.gnu.org/licenses/>.
 *
 * Author:
 *    Canek Peláez Valdés <canek@ciencias.unam.mx>
 */

namespace MLM.Test {

    public class TestFileTagsMain {

        public static int main(string[] args) {
            GLib.Test.init(ref args);
            var source_root = GLib.Path.build_filename(
                GLib.Environment.get_current_dir(), "..");
            if (args.length == 2)
                source_root = args[1];
            var test = new TestFileTags(source_root);
            GLib.TestSuite.get_root().add_suite(test.get_suite());
            return GLib.Test.run();
        }
    }
}
