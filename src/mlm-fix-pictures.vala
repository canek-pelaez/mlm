using Id3Tag;

namespace MLM {

    public static bool fix_picture_frame(Frame frame, PictureType picture_type, string str) {
        bool modified = false;
        for (int i = 0; i < frame.fields.length; i++) {
            Field field = frame.field(i);
            if (field.type == FieldType.TEXTENCODING &&
                field.gettextencoding() != FieldTextEncoding.UTF_8) {
                field.settextencoding(FieldTextEncoding.UTF_8);
                modified = true;
            }
            if (field.type == FieldType.LATIN1 &&
                field.getlatin1() != "image/jpeg") {
                field.setlatin1("image/jpeg");
                modified = true;
            }
            if (field.type == FieldType.INT8 && field.getint() != picture_type) {
                field.setint(picture_type);
                modified = true;
            }
            if (field.type == FieldType.STRING) {
                uint32* s = field.getstring();
                string us = UCS4.utf8duplicate(s);
                if (str != us) {
                    uint32* ss = UTF8.ucs4duplicate(str);
                    field.setstring(ss);
                    modified = true;
                }
            }
        }
        return modified;
    }

    public static bool fix_cover_frame(Frame frame, string album) {
        return fix_picture_frame(frame, PictureType.COVERFRONT, album + " cover");
    }

    public static bool fix_artist_frame(Frame frame, string artist) {
        return fix_picture_frame(frame, PictureType.ARTIST, artist);
    }

    public void fix_pictures(string filename) {
        if (!FileUtils.test(filename, FileTest.EXISTS)) {
            stderr.printf("No such file: '%s'\n", filename);
            return;
        }
        File file = new File(filename, FileMode.READWRITE);
        Tag tag = file.tag();

        Frame frame = tag.search_frame("TPE1");
        if (frame == null) {
            file.close();
            return;
        }
        string artist = frame.get_text();
        frame = tag.search_frame("TALB");
        if (frame == null) {
            file.close();
            return;
        }
        string album = frame.get_text();
        bool mod_cover = false;
        bool mod_artist = false;
        frame = tag.search_picture_frame(PictureType.COVERFRONT);
        if (frame != null)
            mod_cover = fix_cover_frame(frame, album);
        frame = tag.search_picture_frame(PictureType.ARTIST);
        if (frame != null)
            mod_artist = fix_cover_frame(frame, artist);
        if (mod_cover || mod_artist) {
            stdout.printf("Updating %s...\n", filename);
            tag.options(TagOption.COMPRESSION, 0);
            file.update();
        }
        tag.delete();
        file.close();
    }

    public static int main(string[] args) {
        for (int i = 1; i < args.length; i++) {
            fix_pictures(args[i]);
        }

        return 0;
    }
}
