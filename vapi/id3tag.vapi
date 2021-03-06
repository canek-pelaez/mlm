/*
 * This file is part of mlm.
 *
 * Copyright © 2013-2019 Canek Peláez Valdés
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

namespace Id3Tag {

    /**
     * The file opening mode.
     */
    [CCode(cheader_filename = "id3tag.h",
           cname            = "enum id3_file_mode",
           cprefix          = "ID3_FILE_MODE_")]
    public enum FileMode {
          READONLY  = 0,
          READWRITE = 1
    }

    /**
     * The tag option.
     */
    [CCode(cheader_filename = "id3tag.h",
           cname            = "enum id3_file_mode",
           cprefix          = "ID3_TAG_OPTION_")]
    public enum TagOption {
        UNSYNCHRONISATION = 0x0001, /* use unsynchronisation */
        COMPRESSION       = 0x0002, /* use compression */
        CRC               = 0x0004, /* use CRC */
        APPENDEDTAG       = 0x0010, /* tag will be appended */
        FILEALTERED       = 0x0020, /* audio data was altered */
        ID3V1             = 0x0100  /* render ID3v1/ID3v1.1 tag */
    }

    /**
     * The file text encoding.
     */
    [CCode(cheader_filename = "id3tag.h",
           cname            = "enum id3_field_textencoding",
           cprefix          = "ID3_FIELD_TEXTENCODING_")]
    public enum FieldTextEncoding {
        ISO_8859_1 = 0x00,
        UTF_16     = 0x01,
        UTF_16BE   = 0x02,
        UTF_8      = 0x03
    }

    /**
     * The field type.
     */
    [CCode(cheader_filename = "id3tag.h",
           cname            = "enum id3_field_type",
           cprefix          = "ID3_FIELD_TYPE_")]
    public enum FieldType {
        TEXTENCODING,
        LATIN1,
        LATIN1FULL,
        LATIN1LIST,
        STRING,
        STRINGFULL,
        STRINGLIST,
        LANGUAGE,
        FRAMEID,
        DATE,
        INT8,
        INT16,
        INT24,
        INT32,
        INT32PLUS,
        BINARYDATA
    }

    /**
     * Enumeration of types of picture.
     * http://id3lib.sourceforge.net/id3/id3v2.4.0-structure.txt
     */
    [CCode(cheader_filename = "id3tag-x.h",
           cname            = "enum id3_picture_type",
           cprefix          = "ID3_PICTURETYPE_")]
    public enum PictureType {
        OTHER         = 0,  /* Other */
        PNG32ICON     = 1,  /* 32x32 pixels 'file icon' (PNG only) */
        OTHERICON     = 2,  /* Other file icon */
        COVERFRONT    = 3,  /* Cover (front) */
        COVERBACK     = 4,  /* Cover (back) */
        LEAFLETPAGE   = 5,  /* Leaflet page */
        MEDIA         = 6,  /* Media (e.g. lable side of CD) */
        LEADARTIST    = 7,  /* Lead artist/lead performer/soloist */
        ARTIST        = 8,  /* Artist/performer */
        CONDUCTOR     = 9,  /* Conductor */
        BAND          = 10, /* Band/Orchestra */
        COMPOSER      = 11, /* Composer */
        LYRICIST      = 12, /* Lyricist/text writer */
        REC_LOCATION  = 13, /* Recording Location */
        RECORDING     = 14, /* During recording */
        PERFORMANCE   = 15, /* During performance */
        VIDEO         = 16, /* Movie/video screen capture */
        FISH          = 17, /* A bright coloured fish */
        ILLUSTRATION  = 18, /* Illustration */
        ARTISTLOGO    = 19, /* Band/artist logotype */
        PUBLISHERLOGO = 20  /* Publisher/Studio logotype */
    }

    /**
     * Class for files with ID3 tags.
     */
    [CCode(cheader_filename = "id3tag.h",
           cname            = "struct id3_file",
           cprefix          = "id3_file_",
           ref_function     = "",
           unref_function   = "")]
    [Compact]
    public class File {

        /**
         * Constructs a new file.
         * @param filename the file name.
         * @param mode the file mode.
         */
        [CCode(cname = "id3_file_open")]
        public File(string filename, FileMode mode);

        /**
         * Closes the file.
         */
        public void close();

        /**
         * Returns the tag instance for the file.
         * @return the tag instance for the file.
         */
        public Tag tag();

        /**
         * Updates the tags of the file.
         */
        public void update();
    }

    /**
     * Class for ID3 tags.
     */
    [CCode(cheader_filename = "id3tag.h",
           cname            = "struct id3_tag",
           cprefix          = "id3_tag_",
           ref_function     = "",
           unref_function   = "")]
    [Compact]
    public class Tag {

        /**
         * Construct a new tag instance.
         */
        [CCode(cname = "id3_tag_new")]
        public Tag();

        /**
         * Returns the version of the tag.
         * @return the version of the tag.
         */
        public uint32 version();

        /**
         * Returns the options of the tag.
         * @param options
         * @return the options of the tag.
         */
        public int32 options(int options, int b);
        public void clearframes();
        public int attachframe(Frame frame);
        public int detachframe(Frame frame);
        public void setlength(long length);
        public void delete();
        public Frame? findframe(string id, uint32 index);
        [CCode (array_length_cname = "nframes", array_length_type = "int32")]
        public unowned Frame[] frames;

        /* Extra API added with id3tag-x */

        [CCode(cheader_filename = "id3tag-x.h")]
        public Frame? search_picture_frame(PictureType picture_type);
        [CCode(cheader_filename = "id3tag-x.h")]
        public Frame? search_frame(string id);
        [CCode(cheader_filename = "id3tag-x.h")]
        public Frame create_text_frame(string id);
        [CCode(cheader_filename = "id3tag-x.h")]
        public Frame create_comment_frame(string lang);
        [CCode(cheader_filename = "id3tag-x.h")]
        public Frame create_picture_frame(PictureType picture_type);
    }

    [CCode(cheader_filename = "id3tag.h",
           cname            = "struct id3_frame",
           cprefix          = "id3_frame_",
           ref_function     = "",
           unref_function   = "")]
    [Compact]
    public class Frame {
        [CCode(cname = "id3_frame_new")]
        public Frame(string id);
        public string id;
        public string description;
        public Field field(uint32 fid);
        public void delete();
        [CCode (array_length_cname = "nfields", array_length_type = "int32")]
        public unowned Field[] fields;
        /* Extra API added with id3tag-x */
        [CCode(cheader_filename = "id3tag-x.h")]
        public string? get_text();
        [CCode(cheader_filename = "id3tag-x.h")]
        public void set_text(string text);
        [CCode(cheader_filename = "id3tag-x.h")]
        public void set_comment_text(string text);
        [CCode(cheader_filename = "id3tag-x.h")]
        public string get_comment_text();
        [CCode(cheader_filename = "id3tag-x.h")]
        public void set_picture(uint8[] bytes, string desc);
        [CCode(cheader_filename = "id3tag-x.h")]
        public Field? get_binary_field();
        [CCode(cheader_filename = "id3tag-x.h")]
        public unowned uint8[] get_picture(PictureType picture_type);
        [CCode(cheader_filename = "id3tag-x.h")]
        public PictureType get_picture_type();
        [CCode(cheader_filename = "id3tag-x.h")]
        public string get_picture_description();
        [CCode(cheader_filename = "id3tag-x.h")]
        public void set_picture_description(string desc);
    }

    [CCode(cheader_filename = "id3tag.h",
           cname            = "union id3_field",
           cprefix          = "id3_field_",
           ref_function     = "",
           unref_function   = "")]
    [Compact]
    public class Field {
        public FieldType type;
        public FieldTextEncoding gettextencoding();
        public unowned string getlatin1();
        public long getint();
        public unowned uint32* getstring();
        public unowned uint32* getfullstring();
        public unowned uint32* getstrings(int i);
        public void settextencoding(FieldTextEncoding text_encoding);
        public void setlatin1(string latin1);
        public void setlanguage(string lang);
        public void setint(long n);
        public void setstring(uint32* s);

        /* Union fields as properties */

        [CCode (cname = "number.value")]
        public long number_value;
        [CCode (cname = "stringlist.strings",
                array_length_cname = "stringlist.nstrings",
                array_length_type = "int32")]
        public unowned  uint32*[] stringlist;
        [CCode (cname = "binary.data",
                array_length_cname = "binary.length",
                array_length_type = "int32")]
        public unowned  uint8[] binary_data;
        [CCode (cname = "immediate.value",
                array_length = "9",
                array_length_type = "int32")]
        public unowned  char[] immediate_value;
    }

    namespace UCS4 {
        [CCode (cname = "id3_ucs4_utf8duplicate")]
        public static unowned string utf8duplicate(uint32* data);
    }

    namespace UTF8 {
        [CCode (cname = "id3_utf8_ucs4duplicate")]
        public static unowned uint32* ucs4duplicate(string s);
    }
}
