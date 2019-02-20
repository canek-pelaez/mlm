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
     * Enumeration for colors.
     */
    public enum Color {
        GRAY   = 0,
        RED    = 1,
        GREEN  = 2,
        YELLOW = 3,
        BLUE   = 4,
        PURPLE = 5,
        CYAN   = 6,
        NONE   = 999;
    }

    /**
     * Class for utility functions.
     */
    public class Util {

        /* Whether the get_colorize() function has been called. */
        private static bool get_colorize_called = false;
        /* Whether to colorize. */
        private static bool colorize = true;
        /* The don't colorize environment variable. */
        private const string MLM_DONT_COLORIZE = "MLM_DONT_COLORIZE";

        /**
         * Returns a colorized message.
         * @param message the message.
         * @param color the color.
         * @return a colorized message.
         */
        public static string color(string message, Color color) {
            if (!get_colorize() || color == Color.NONE)
                return message;
            return "\033[1m\033[9%dm%s\033[0m".printf(color, message);
        }

        /**
         * Returns the modification time of a file.
         * @param filename the file name.
         * @return the modification time of a file.
         */
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

        /**
         * Sets the modification time of a file.
         * @param filename the file name.
         * @param time the modification time.
         */
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

        /**
         * Returns the NFKD normalization and ASCII conversion of a string.
         * @param str the string.
         * @return the NFKD normalization and ASCII conversion of the string.
         */
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

        /**
         * Whether to colorize or not.
         * @return ''true'' if we should colorize; ''false'' otherwise.
         */
        private static bool get_colorize() {
            if (get_colorize_called)
                return colorize;
            get_colorize_called = true;
            colorize = GLib.Environment.get_variable(MLM_DONT_COLORIZE) != "1";
            return colorize;
        }

        /**
         * Sets the locale for a category.
         * @param category the category.
         */
        public static void set_locale(GLib.LocaleCategory category) {
            switch (category) {
            case GLib.LocaleCategory.ALL:      break;
            case GLib.LocaleCategory.COLLATE:  break;
            case GLib.LocaleCategory.CTYPE:    break;
            case GLib.LocaleCategory.MESSAGES: break;
            case GLib.LocaleCategory.MONETARY: break;
            case GLib.LocaleCategory.NUMERIC:
                var NUMERIC = GLib.Environment.get_variable("LC_NUMERIC");
                if (NUMERIC == null)
                    NUMERIC = GLib.Environment.get_variable("LANG");
                GLib.Intl.setlocale(GLib.LocaleCategory.NUMERIC, NUMERIC);
                break;
            case GLib.LocaleCategory.TIME:     break;
            }
        }

        /**
         * Prints an error message in the standard error.
         * @param help whether to print a help message.
         * @param code the exit code.
         * @param command the command where the error occurred.
         * @param format the message format.
         * @param ... the message parameters.
         */
        [PrintfFormat]
        public static void error(bool   help,
                                 int    code,
                                 string command,
                                 string format,
                                 ...) {
            string full_format = "error: " + format + "\n";
            var list = va_list();
            stdout.vprintf(full_format, list);
            if (help)
                stderr.printf("Run ‘%s --help’ for a list of options.\n",
                              command);
            Process.exit(code);
        }

        public static string? normal_form(FileTags tags) {
            if (tags.artist == null || tags.title == null || tags.album == null)
                return null;
            var artist = asciize(tags.artist);
            var title = asciize(tags.title);
            var album = asciize(tags.album);
            var band = artist;
            if (tags.band != null)
                band = asciize(tags.band);
            int disc = tags.disc;
            int track = tags.track;

            var letter = band.get_char(0).to_string();

            var name = (disc != -1 && track != -1) ?
                "%d_-_%02d_-_%s_-_%s.mp3".printf(disc, track,
                                                    artist, title) :
                "%s_-_%s.mp3".printf(artist, title);

            return string.join(GLib.Path.DIR_SEPARATOR_S,
                               letter, band, album, name);
        }
    }
}
