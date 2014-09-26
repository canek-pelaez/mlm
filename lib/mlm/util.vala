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

    public enum Color {
        GRAY   = 0,
        RED    = 1,
        GREEN  = 2,
        YELLOW = 3,
        BLUE   = 4,
        PURPLE = 5,
        CYAN   = 6,
        NONE   = 999
    }

    public class Util {

        public static string color(string s, Color c) {
            if (c == Color.NONE)
                return s;
            return "\033[1m\033[9%dm%s\033[0m".printf(c, s);
        }

        public static GLib.TimeVal get_file_time(string filename) {
            try {
                var file = GLib.File.new_for_path(filename);
                var info = file.query_info("time::modified",
                                           GLib.FileQueryInfoFlags.NONE);
                return info.get_modification_time();
            } catch (GLib.Error e) {
                GLib.warning("There was an error reading from ‘%s’.\n", filename);
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
                GLib.warning("There was an error writing to ‘%s’.\n", filename);
            }
        }

        public static string asciize(string str) {
            var s = str.normalize(-1, GLib.NormalizeMode.NFKD);
            try {
                uint8[] outbuf = new uint8[s.length + 1]; // '\0' at end.
                size_t read = s.length;
                size_t written = 0;

                var conv = new GLib.CharsetConverter("ASCII//IGNORE", "UTF-8");
                var r = conv.convert(s.data, outbuf, ConverterFlags.NONE,
                                     out read, out written);
                string t = (string)outbuf;

                if (r == GLib.ConverterResult.ERROR)
                    return "";

                t = t.down();
                t = t.replace("&", "and");
                var regex = new GLib.Regex("[ /-]");
                t = regex.replace(t, t.length, 0, "_");
                regex = new GLib.Regex("[^A-Za-z0-9_-]");
                t = regex.replace(t, t.length, 0, "");
                t = t.replace("mp3", ".mp3");
                return t;
            } catch (GLib.Error e) {
                GLib.warning("%s", e.message);
            }
            return "";
        }
    }
}
