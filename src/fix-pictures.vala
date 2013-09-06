using Id3Tag;

namespace MusicCollection {

    public static string? frame_get_text(Frame frame) {
        for (int i = 0; i < frame.fields.length; i++) {
            Field field = frame.field(i);
            if (field.type != FieldType.STRINGLIST)
                continue;
            for (int j = 0; j < field.stringlist.length; j++) {
                unowned uint32* s = field.getstrings(j);
                string us = UCS4.utf8duplicate(s);
                return us;
            }
        }
        return null;
    }

    public static Frame? id3_tag_search_picture_frame(Tag tag, PictureType picture_type) {
        for (int i = 0; i < tag.frames.length; i++) {
            Frame frame = tag.frames[i];
            if (frame.id != "APIC")
                continue;
            for (int j = 0; j < frame.fields.length; j++) {
                Field field = frame.field(j);
                if (field.type != FieldType.INT8)
                    continue;
                if (field.number_value == picture_type)
                    return frame;
            }
        }
        return null;
    }

    public static Frame? tag_search_frame(Tag tag, string id) {
        for (int i = 0; i < tag.frames.length; i++) {
            unowned Frame frame = tag.frames[i];
            if (frame.id == id)
                return frame;
        }
        return null;
    }

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
        stdout.printf("Processing %s...\n", filename);
        File file = new File(filename, FileMode.READWRITE);
        Tag tag = file.tag();

        tag.options(TagOption.COMPRESSION, 0);

        Frame frame = tag_search_frame(tag, "TPE1");
        if (frame == null)
            return;
        string artist = frame_get_text(frame);
        frame = tag_search_frame(tag, "TALB");
        if (frame == null)
            return;
        string album = frame_get_text(frame);
        bool mod_cover = false;
        bool mod_artist = false;
        frame = id3_tag_search_picture_frame(tag, PictureType.COVERFRONT);
        if (frame != null)
            mod_cover = fix_cover_frame(frame, album);
        frame = id3_tag_search_picture_frame(tag, PictureType.ARTIST);
        if (frame != null)
            mod_artist = fix_cover_frame(frame, artist);
        if (mod_cover || mod_artist) {
            stdout.printf("Updating %s...\n", filename);
            file.update();
        } else {
            stdout.printf("Skipping %s...\n", filename);
        }
        file.close();
    }

    public static int main(string[] args) {
        int i;
        for (i = 1; i < args.length; i++) {
            if (args[i].length < 4)
                continue;
            if (!args[i].has_suffix(".mp3"))
                continue;
            fix_pictures(args[i]);
        }

        return 0;
    }
}
