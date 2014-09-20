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

    public class Util {

        public static string term_gray(string s) {
            return "\033[1m\033[90m%s\033[0m".printf(s);
        }

        public static string term_red(string s) {
            return "\033[1m\033[91m%s\033[0m".printf(s);
        }

        public static string term_green(string s) {
            return "\033[1m\033[92m%s\033[0m".printf(s);
        }

        public static string term_yellow(string s) {
            return "\033[1m\033[93m%s\033[0m".printf(s);
        }

        public static string term_blue(string s) {
            return "\033[1m\033[94m%s\033[0m".printf(s);
        }

        public static string term_purple(string s) {
            return "\033[1m\033[95m%s\033[0m".printf(s);
        }

        public static string term_cyan(string s) {
            return "\033[1m\033[96m%s\033[0m".printf(s);
        }

        public static string term_key_value(string key, string value) {
            return "%s: %s".printf(term_blue(key),
                                   term_yellow(value));
        }

        public static GLib.TimeVal get_file_time(string filename) {
            try {
                var file = GLib.File.new_for_path(filename);
                var info = file.query_info("time::modified",
                                                     GLib.FileQueryInfoFlags.NONE);
                return info.get_modification_time();
            } catch (GLib.Error e) {
                stderr.printf("There was an error reading from '%s'.\n", filename);
            }
            return GLib.TimeVal();
        }

        public static void set_file_time(string filename, GLib.TimeVal time) {
            try {
                var file = GLib.File.new_for_path(filename);
                var info = new GLib.FileInfo();
                info.set_attribute_uint64("time::modified", (uint64)time.tv_sec);
                info.set_attribute_uint32("time::modified-usec", (uint32)time.tv_usec);
                info.set_attribute_uint64("time::access", (uint64)time.tv_sec);
                info.set_attribute_uint32("time::access-usec", (uint32)time.tv_usec);
                file.set_attributes_from_info(info, GLib.FileQueryInfoFlags.NONE);
            } catch (GLib.Error e) {
                stderr.printf("There was an error writing to '%s'.\n", filename);
            }
        }

        public static string asciize(string str) {
            var s = str.normalize(-1, GLib.NormalizeMode.NFKD);
            try {
                uint8[] outbuf = new uint8[s.length];
                size_t read = s.length;
                size_t written = 0;

                var conv = new GLib.CharsetConverter("ASCII//IGNORE", "UTF-8");
                var r = conv.convert(s.data, outbuf, ConverterFlags.NONE,
                                     out read, out written);
                string t = (string)outbuf;

                if (r == GLib.ConverterResult.ERROR)
                    return "";

                t = t.down();
                var regex = new GLib.Regex("[\\[\\]#:\\.,?!/)(\\']");
                t = regex.replace(t, t.length, 0, "");
                t = t.replace("&", "and");
                t = t.replace(" ", "_");
                t = t.replace("/", "_");
                t = t.replace("-", "_");
                if (t.has_suffix("mp3"))
                    t = t.replace("mp3", ".mp3");
                return t;
            } catch (GLib.Error e) {
                GLib.warning("%s", e.message);
            }
            return "";
        }
    }
}
