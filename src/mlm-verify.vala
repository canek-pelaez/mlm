using Id3Tag;

namespace MLM {

    namespace Verify {

        public static void verify_file(string filename) {
            if (!FileUtils.test(filename, FileTest.EXISTS)) {
                stderr.printf("%s: No such file.\n", filename);
                return;
            }
            File file = new File(filename, FileMode.READWRITE);
            if (file == null) {
                stderr.printf("%s: Could not link to file.\n", filename);
                return;
            }
            Tag tag = file.tag();
            if (tag == null) {
                stderr.printf("%s: Could not extract tags from file.\n", filename);
                return;
            }
            stdout.printf("%s:\n", filename);
            if (tag.frames.length == 0) {
                stdout.printf("\tFile has no frames.\n");
                return;
            }
            for (int i = 0; i < tag.frames.length; i++) {
                Frame frame = tag.frames[i];
                if (frame.id == FrameId.ARTIST) {
                }
            }
        }

        public static int main(string[] args) {
            for (int i = 1; i < args.length; i++)
                verify_file(args[i]);

            return 0;
        }
    }
}
