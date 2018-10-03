/*
 * This file is part of mlm.
 *
 * Copyright © 2013-2018 Canek Peláez Valdés
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

    public class PrettyBox {

        private class Word {
            public string word;
            public Color color;

            public Word(string word, Color color) {
                this.word = word;
                this.color = color;
            }

            public string to_string() {
                return Util.color(word, color);
            }
        }

        private class Line {
            public Gee.ArrayList<Word> words;
            public int width;

            public Line() {
                words = new Gee.ArrayList<Word>();
                width = 0;
            }

            public void add_word(Word word, bool add_space = true) {
                if (width > 0 && add_space)
                    word.word = " " + word.word;
                words.add(word);
                width += word.word.char_count();
            }

            public string to_string() {
                string r = "";
                foreach (var word in words) {
                    r += word.to_string();
                }
                return r;
            }
        }

        private int columns;
        private Color border;
        private Gee.ArrayList<Line> title;
        private Gee.ArrayList<Line> body;

        public PrettyBox(int columns, Color border) {
            this.columns = columns;
            this.border = border;
            body = new Gee.ArrayList<Line>();
            body.add(new Line());
        }

        private string ellipsize(string word, int width) {
            unowned string s = word.next_char();
            string r = "";
            for (int i = 0; i < width / 2 - 1; i++) {
                r += s;
                s = s.next_char();
            }
            r += "...";
            for (int i = 0; i < word.char_count() - width - 3; i++)
                s = s.next_char();
            for (int i = width / 2 + 2; i < width; i++) {
                r += s;
                s = s.next_char();
            }
            return s;
        }

        private void process_strings(Gee.ArrayList<Line> lines,
                                     string strings, Color color) {
            var line = lines.last();
            var words = strings.split(" ");
            for (int i = 0; i < words.length; i++)
                if (words[i].char_count() > columns - 8)
                    words[i] = ellipsize(words[i], columns - 8);
            for (int i = 0; i < words.length; i++) {
                if (line.width + words[i].char_count() > columns - 3) {
                    line = new Line();
                    line.add_word(new Word("  ", Color.NONE));
                    lines.add(line);
                }
                line.add_word(new Word(words[i], color));
            }
        }

        public void set_title(string title, Color color) {
            this.title = new Gee.ArrayList<Line>();
            this.title.add(new Line());
            process_strings(this.title, title, color);
        }

        public void add_body_strings(string strings, Color color) {
            process_strings(body, strings, color);
        }

        public void add_body_separator(string separator) {
            var line = body.last();
            line.add_word(new Word(separator, Color.NONE), false);
        }

        public void add_body_newline() {
            body.add(new Line());
        }

        public void add_body_key_value(string key, string value) {
            add_body_strings(key, Color.BLUE);
            add_body_separator(":");
            add_body_strings(value, Color.YELLOW);
            add_body_newline();
        }

        public string to_string() {
            var r = Util.color("┏", border);
            for (int i = 0; i < columns - 2; i++)
                r += Util.color("━", border);
            r += Util.color("┓", border) + "\n";

            foreach (var line in title) {
                r += Util.color("┃", border) + line.to_string();
                for (int i = line.width; i < columns - 2; i++)
                    r += " ";
                r += Util.color("┃", border) + "\n";
            }

            r += Util.color("┠", border);
            for (int i = 0; i < columns - 2; i++)
                r += Util.color("─", border);
            r += Util.color("┨", border) + "\n";

            foreach (var line in body) {
                if (line.width == 0)
                    continue;
                r += Util.color("┃", border) + line.to_string();
                for (int i = line.width; i < columns - 2; i++)
                    r += " ";
                r += Util.color("┃", border) + "\n";
            }

            r += Util.color("┗", border);
            for (int i = 0; i < columns - 2; i++)
                r += Util.color("━", border);
            r += Util.color("┛", border) + "\n";

            return r;
        }
    }
}