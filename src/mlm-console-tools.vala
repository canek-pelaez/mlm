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

namespace MLM {

    public class ConsoleTools {

        public static string gray(string s) {
            return "\033[1m\033[90m%s\033[0m".printf(s);
        }
        public static string red(string s) {
            return "\033[1m\033[91m%s\033[0m".printf(s);
        }
        public static string green(string s) {
            return "\033[1m\033[92m%s\033[0m".printf(s);
        }
        public static string yellow(string s) {
            return "\033[1m\033[93m%s\033[0m".printf(s);
        }
        public static string blue(string s) {
            return "\033[1m\033[94m%s\033[0m".printf(s);
        }
        public static string purple(string s) {
            return "\033[1m\033[95m%s\033[0m".printf(s);
        }
        public static string cyan(string s) {
            return "\033[1m\033[96m%s\033[0m".printf(s);
        }
    }
}
