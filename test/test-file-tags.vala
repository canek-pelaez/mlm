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

namespace MLM.Test {

    /**
     * Test cases for {@link FileTags}.
     */
    public class TestFileTags : MLM.Test.TestCase {

        /* Empty test MP3. */
        private string data_empty_mp3;
        /* Full test MP3. */
        private string data_full_mp3;
        /* Test cover picture. */
        private string test_cover_png;
        /* Test artist picture. */
        private string test_artist_png;
        /* Empty test file. */
        private GLib.File empty_mp3;
        /* Full test file. */
        private GLib.File full_mp3;

        /**
         * Constructs the test suite.
         */
        public TestFileTags(string source_root) {
            base("TestFileTags");
            data_empty_mp3 = GLib.Path.build_filename(
                source_root, "data", "test", "empty.mp3");
            data_full_mp3 = GLib.Path.build_filename(
                source_root, "data", "test", "full.mp3");
            test_cover_png = GLib.Path.build_filename(
                source_root, "data", "test", "test-cover.png");
            test_artist_png = GLib.Path.build_filename(
                source_root, "data", "test", "test-artist.png");
            add_test("test_artist",         test_artist);
            add_test("test_title",          test_title);
            add_test("test_album",          test_album);
            add_test("test_band",           test_band);
            add_test("test_year",           test_year);
            add_test("test_track",          test_track);
            add_test("test_disc",           test_disc);
            add_test("test_genre",          test_genre);
            add_test("test_comment",        test_comment);
            add_test("test_composer",       test_composer);
            add_test("test_original",       test_original);
            add_test("test_artist_picture", test_artist_picture);
            add_test("test_cover_picture",  test_cover_picture);
        }

        /**
         * Sets up the test.
         */
        public override void set_up() {
            size_t written;
            GLib.FileIOStream empty_ios;
            GLib.FileIOStream full_ios;
            try {
                uint8[] data_empty;
                GLib.assert(GLib.FileUtils.get_data(data_empty_mp3,
                                                    out data_empty));
                empty_mp3 = GLib.File.new_tmp(null, out empty_ios);
                GLib.FileOutputStream empty_out =
                    empty_ios.output_stream as GLib.FileOutputStream;
                GLib.assert(empty_out.write_all(data_empty, out written));

                uint8[] data_full;
                GLib.assert(GLib.FileUtils.get_data(data_full_mp3,
                                                    out data_full));
                full_mp3 = GLib.File.new_tmp(null, out full_ios);
                GLib.FileOutputStream full_out =
                    full_ios.output_stream as GLib.FileOutputStream;
                GLib.assert(full_out.write_all(data_full, out written));
            } catch (Error error) {
                GLib.assert(false);
            }
        }

        /**
         * Tears down the test.
         */
        public override void tear_down() {
            GLib.FileUtils.remove(empty_mp3.get_path());
            GLib.FileUtils.remove(full_mp3.get_path());
            empty_mp3 = null;
            full_mp3 = null;
        }

        /* Test setting the artist in a test file. */
        private void test_artist_file(GLib.File file, string? original,
                                      string val1, string val2) {
            var path = file.get_path();
            var tags = new FileTags(path);
            GLib.assert(tags.artist == original);
            tags.artist = val1;
            GLib.assert(tags.artist == val1);
            tags.update();
            tags = null;
            tags = new FileTags(path);
            GLib.assert(tags.artist == val1);
            tags.artist = val2;
            GLib.assert(tags.artist == val2);
            tags.update();
            tags = null;
            tags = new FileTags(path);
            GLib.assert(tags.artist == val2);
            tags = null;
        }

        /**
         * Test for adding an artist to {@link FileTags}.
         */
        public void test_artist() {
            test_artist_file(empty_mp3, null, "Artist", "Artist X");
            test_artist_file(full_mp3, "A", "Artist", "Artist X");
        }

        /* Test setting the title in a test file. */
        private void test_title_file(GLib.File file, string? original,
                                      string val1, string val2) {
            var path = file.get_path();
            var tags = new FileTags(path);
            GLib.assert(tags.title == original);
            tags.title = val1;
            GLib.assert(tags.title == val1);
            tags.update();
            tags = null;
            tags = new FileTags(path);
            GLib.assert(tags.title == val1);
            tags.title = val2;
            GLib.assert(tags.title == val2);
            tags.update();
            tags = null;
            tags = new FileTags(path);
            GLib.assert(tags.title == val2);
            tags = null;
        }

        /**
         * Test for adding a title to {@link FileTags}.
         */
        public void test_title() {
            test_title_file(empty_mp3, null, "Title", "Title X");
            test_title_file(full_mp3, "T", "Title", "Title X");
        }

        /* Test setting the album in a test file. */
        private void test_album_file(GLib.File file, string? original,
                                     string val1, string val2) {
            var path = file.get_path();
            var tags = new FileTags(path);
            GLib.assert(tags.album == original);
            tags.album = val1;
            GLib.assert(tags.album == val1);
            tags.update();
            tags = null;
            tags = new FileTags(path);
            GLib.assert(tags.album == val1);
            tags.album = val2;
            GLib.assert(tags.album == val2);
            tags.update();
            tags = null;
            tags = new FileTags(path);
            GLib.assert(tags.album == val2);
            tags = null;
        }

        /**
         * Test for adding an album to {@link FileTags}.
         */
        public void test_album() {
            test_album_file(empty_mp3, null, "Album", "Album X");
            test_album_file(full_mp3, "L", "Album", "Album X");
        }

        /* Test setting the band in a test file. */
        private void test_band_file(GLib.File file, string? original,
                                    string val1, string val2) {
            var path = file.get_path();
            var tags = new FileTags(path);
            GLib.assert(tags.band == original);
            tags.band = val1;
            GLib.assert(tags.band == val1);
            tags.update();
            tags = null;
            tags = new FileTags(path);
            GLib.assert(tags.band == val1);
            tags.band = val2;
            GLib.assert(tags.band == val2);
            tags.update();
            tags = null;
            tags = new FileTags(path);
            GLib.assert(tags.band == val2);
            tags = null;
        }

        /**
         * Test for adding a band to {@link FileTags}.
         */
        public void test_band() {
            test_band_file(empty_mp3, null, "Banda", "Banda X");
            test_band_file(full_mp3, "B", "Banda", "Banda X");
        }

        /**
         * Test for adding a year to {@link FileTags}.
         */
        public void test_year() {
            var path = empty_mp3.get_path();
            var tags = new FileTags(path);
            GLib.assert(tags.year == -1);
            tags.year = 2000;
            GLib.assert(tags.year == 2000);
            tags.update();
            tags = null;
            tags = new FileTags(path);
            GLib.assert(tags.year == 2000);
            tags.year = 2010;
            GLib.assert(tags.year == 2010);
            tags.update();
            tags = null;
            tags = new FileTags(path);
            GLib.assert(tags.year == 2010);
            tags = null;
        }

        /**
         * Test for adding a track to {@link FileTags}.
         */
        public void test_track() {
            var path = empty_mp3.get_path();
            var tags = new FileTags(path);
            GLib.assert(tags.track == -1);
            GLib.assert(tags.total == -1);
            tags.track = 3;
            GLib.assert(tags.track == 3);
            GLib.assert(tags.total == 3);
            tags.update();
            tags = null;
            tags = new FileTags(path);
            GLib.assert(tags.track == 3);
            GLib.assert(tags.total == 3);
            tags.track = 7;
            GLib.assert(tags.track == 7);
            GLib.assert(tags.total == 7);
            tags.update();
            tags = null;
            tags = new FileTags(path);
            GLib.assert(tags.track == 7);
            GLib.assert(tags.total == 7);
            tags = null;
        }

        /**
         * Test for adding a total to {@link FileTags}.
         */
        public void test_total() {
            var path = empty_mp3.get_path();
            var tags = new FileTags(path);
            GLib.assert(tags.track == -1);
            GLib.assert(tags.total == -1);
            tags.total = 2;
            GLib.assert(tags.track == -1);
            GLib.assert(tags.total == 2);
            tags.update();
            tags = null;
            tags = new FileTags(path);
            GLib.assert(tags.track == -1);
            GLib.assert(tags.total == 2);
            tags.total = 6;
            tags.update();
            tags = null;
            tags = new FileTags(path);
            GLib.assert(tags.track == -1);
            GLib.assert(tags.total == 6);
            tags = null;
        }

        /**
         * Test for adding a disc to {@link FileTags}.
         */
        public void test_disc() {
            var path = empty_mp3.get_path();
            var tags = new FileTags(path);
            GLib.assert(tags.disc == -1);
            tags.disc = 1;
            GLib.assert(tags.disc == 1);
            tags.update();
            tags = null;
            tags = new FileTags(path);
            GLib.assert(tags.disc == 1);
            tags.disc = 2;
            GLib.assert(tags.disc == 2);
            tags.update();
            tags = null;
            tags = new FileTags(path);
            GLib.assert(tags.disc == 2);
            tags = null;
        }

        /**
         * Test for adding a genre to {@link FileTags}.
         */
        public void test_genre() {
            var path = empty_mp3.get_path();
            var tags = new FileTags(path);
            GLib.assert(tags.genre == -1);
            tags.genre = 1;
            GLib.assert(tags.genre == 1);
            tags.update();
            tags = null;
            tags = new FileTags(path);
            GLib.assert(tags.genre == 1);
            tags.genre = 2;
            GLib.assert(tags.genre == 2);
            tags.update();
            tags = null;
            tags = new FileTags(path);
            GLib.assert(tags.genre == 2);
            tags = null;
        }

        /* Test setting the comment in a test file. */
        private void test_comment_file(GLib.File file, string? original,
                                       string val1, string val2) {
            var path = file.get_path();
            var tags = new FileTags(path);
            GLib.assert(tags.comment == original);
            tags.comment = val1;
            GLib.assert(tags.comment == val1);
            tags.update();
            tags = null;
            tags = new FileTags(path);
            GLib.assert(tags.comment == val1);
            tags.comment = val2;
            GLib.assert(tags.comment == val2);
            tags.update();
            tags = null;
            tags = new FileTags(path);
            GLib.assert(tags.comment == val2);
            tags = null;
        }

        /**
         * Test for adding a comment to {@link FileTags}.
         */
        public void test_comment() {
            test_comment_file(empty_mp3, null, "Comment", "Comment X");
            test_comment_file(full_mp3, "C", "Comment", "Comment X");
        }

        /**
         * Test for adding a composer to {@link FileTags}.
         */
        public void test_composer() {
            var path = empty_mp3.get_path();
            var tags = new FileTags(path);
            GLib.assert(tags.composer == null);
            tags.composer = "Composer";
            GLib.assert(tags.composer == "Composer");
            tags.update();
            tags = null;
            tags = new FileTags(path);
            GLib.assert(tags.composer == "Composer");
            tags.composer = "Composer X";
            GLib.assert(tags.composer == "Composer X");
            tags.update();
            tags = null;
            tags = new FileTags(path);
            GLib.assert(tags.composer == "Composer X");
            tags = null;
        }

        /**
         * Test for adding an original to {@link FileTags}.
         */
        public void test_original() {
            var path = empty_mp3.get_path();
            var tags = new FileTags(path);
            GLib.assert(tags.original == null);
            tags.original = "Original";
            GLib.assert(tags.original == "Original");
            tags.update();
            tags = null;
            tags = new FileTags(path);
            GLib.assert(tags.original == "Original");
            tags.original = "Original X";
            GLib.assert(tags.original == "Original X");
            tags.update();
            tags = null;
            tags = new FileTags(path);
            GLib.assert(tags.original == "Original X");
            tags = null;
        }

        /* Asserts two byte arrays are equal. */
        private void assert_bytes_equal(uint8[]? data_a, uint8[]? data_b) {
            if (data_a == data_b)
                return;
            GLib.assert(data_a.length == data_b.length);
            for (int i = 0; i < data_a.length; i++)
                GLib.assert(data_a[i] == data_b[i]);
        }

        /* Gets the picture data from a path. */
        private uint8[] get_picture_data(string path) {
            uint8[] data = { 0 };
            try {
                GLib.assert(GLib.FileUtils.get_data(path, out data));
            } catch (GLib.Error error) {
                GLib.assert(false);
            }
            return data;
        }

        /* Test setting the cover picture in a test file. */
        private void test_cover_picture_file(GLib.File file, uint8[]? original,
                                             uint8[] val1, uint8[] val2) {
            var path = file.get_path();
            var tags = new FileTags(path);
            assert_bytes_equal(tags.cover_picture, original);
            tags.cover_picture = val1;
            GLib.assert(tags.cover_picture != null);
            assert_bytes_equal(tags.cover_picture, val1);
            tags.update();
            tags = null;
            tags = new FileTags(path);
            GLib.assert(tags.cover_picture != null);
            assert_bytes_equal(tags.cover_picture, val1);
            tags.cover_picture = val2;
            GLib.assert(tags.cover_picture != null);
            assert_bytes_equal(tags.cover_picture, val2);
            tags.update();
            tags = null;
            tags = new FileTags(path);
            GLib.assert(tags.cover_picture != null);
            assert_bytes_equal(tags.cover_picture, val2);
        }

        /**
         * Test for adding a cover picture to {@link FileTags}.
         */
        public void test_cover_picture() {
            var data1 = get_picture_data(test_cover_png);
            var data2 = get_picture_data(test_artist_png);
            test_cover_picture_file(empty_mp3, null, data1, data2);
            test_cover_picture_file(full_mp3, data1, data1, data2);
        }

        /* Test setting the artist picture in a test file. */
        private void test_artist_picture_file(GLib.File file, uint8[]? original,
                                             uint8[] val1, uint8[] val2) {
            var path = file.get_path();
            var tags = new FileTags(path);
            assert_bytes_equal(tags.artist_picture, original);
            if (tags.artist != null)
                GLib.assert(tags.artist_picture_description == tags.artist);
            tags.artist_picture = val1;
            GLib.assert(tags.artist_picture != null);
            assert_bytes_equal(tags.artist_picture, val1);
            GLib.assert(tags.artist_picture_description == tags.artist);
            tags.update();
            tags = null;
            tags = new FileTags(path);
            GLib.assert(tags.artist_picture != null);
            assert_bytes_equal(tags.artist_picture, val1);
            if (tags.artist != null)
                GLib.assert(tags.artist_picture_description == tags.artist);
            tags.artist_picture = val2;
            GLib.assert(tags.artist_picture != null);
            assert_bytes_equal(tags.artist_picture, val2);
            if (tags.artist != null)
                GLib.assert(tags.artist_picture_description == tags.artist);
            tags.update();
            tags = null;
            tags = new FileTags(path);
            GLib.assert(tags.artist_picture != null);
            assert_bytes_equal(tags.artist_picture, val2);
            if (tags.artist != null)
                GLib.assert(tags.artist_picture_description == tags.artist);
        }

        /**
         * Test for adding an artist picture to {@link FileTags}.
         */
        public void test_artist_picture() {
            var data1 = get_picture_data(test_artist_png);
            var data2 = get_picture_data(test_cover_png);
            test_artist_picture_file(empty_mp3, null, data1, data2);
            test_artist_picture_file(full_mp3, data1, data1, data2);
        }
    }
}
