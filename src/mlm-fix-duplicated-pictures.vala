using Id3Tag;

namespace MLM {

    public static void fix_duplicated_pictures(string filename) {
        if (!FileUtils.test(filename, FileTest.EXISTS)) {
            stderr.printf("No such file: '%s'\n", filename);
            return;
        }
        File file = new File(filename, FileMode.READWRITE);
        Tag tag = file.tag();
        Frame pf1 = null, pf2 = null;
        for (int i = 0; i < tag.frames.length; i++) {
            Frame frame = tag.frames[i];
            if (frame.id == "APIC") {
                if (pf1 == null) {
                    pf1 = frame;
                } else if (pf2 == null) {
                    pf2 = frame;
                } else {
                    stderr.printf("There are more than 2 picture frames in '%s'\n", filename);
                    return;
                }
            }
        }
        if (pf1 == null || pf2 == null) {
            stderr.printf("The file '%s' doesn't have two picture frames\n", filename);
            return;
        }
        PictureType pf1_type = pf1.get_picture_type();
        PictureType pf2_type = pf2.get_picture_type();
        if (pf1_type != pf2_type) {
            stderr.printf("The file '%s' doesn't have two duplicated picture frames\n", filename);
            return;
        }
        if (pf1_type != PictureType.COVERFRONT && pf1_type != PictureType.ARTIST) {
            stderr.printf("The file '%s' has duplicated picture frames of unknown type\n", filename);
            return;
        }
        for (int i = 0; i < pf2.fields.length; i++) {
            Field field = pf2.field(i);
            if (field.type == FieldType.INT8 && field.getint() == pf1_type) {
                if (pf1_type == PictureType.COVERFRONT) {
                    field.setint(PictureType.ARTIST);
                } else {
                    field.setint(PictureType.COVERFRONT);
                }
            }
        }
        stdout.printf("Updating %s...\n", filename);
        tag.options(TagOption.COMPRESSION, 0);
        file.update();
        tag.delete();
        file.close();
    }

    public static int main(string[] args) {
        for (int i = 1; i < args.length; i++)
            fix_duplicated_pictures(args[i]);

        return 0;
    }
}
