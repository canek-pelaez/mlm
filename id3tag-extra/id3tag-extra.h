#include <id3tag.h>

#ifndef _ID3TAG_EXTRA_H
#define _ID3TAG_EXTRA_H

enum id3_picture_type {
        ID3_PICTURETYPE_OTHER = 0,         /* Other */
        ID3_PICTURETYPE_PNG32ICON = 1,     /* 32x32 pixels 'file icon' (PNG only) */
        ID3_PICTURETYPE_OTHERICON = 2,     /* Other file icon */
        ID3_PICTURETYPE_COVERFRONT = 3,    /* Cover (front) */
        ID3_PICTURETYPE_COVERBACK = 4,     /* Cover (back) */
        ID3_PICTURETYPE_LEAFLETPAGE = 5,   /* Leaflet page */
        ID3_PICTURETYPE_MEDIA = 6,         /* Media (e.g. lable side of CD) */
        ID3_PICTURETYPE_LEADARTIST = 7,    /* Lead artist/lead performer/soloist */
        ID3_PICTURETYPE_ARTIST = 8,        /* Artist/performer */
        ID3_PICTURETYPE_CONDUCTOR = 9,     /* Conductor */
        ID3_PICTURETYPE_BAND = 10,         /* Band/Orchestra */
        ID3_PICTURETYPE_COMPOSER = 11,     /* Composer */
        ID3_PICTURETYPE_LYRICIST = 12,     /* Lyricist/text writer */
        ID3_PICTURETYPE_REC_LOCATION = 13, /* Recording Location */
        ID3_PICTURETYPE_RECORDING = 14,    /* During recording */
        ID3_PICTURETYPE_PERFORMANCE = 15,  /* During performance */
        ID3_PICTURETYPE_VIDEO = 16,        /* Movie/video screen capture */
        ID3_PICTURETYPE_FISH = 17,         /* A bright coloured fish */
        ID3_PICTURETYPE_ILLUSTRATION = 18, /* Illustration */
        ID3_PICTURETYPE_ARTISTLOGO = 19,   /* Band/artist logotype */
        ID3_PICTURETYPE_PUBLISHERLOGO = 20 /* Publisher/Studio logotype */
};

struct id3_frame*     id3_tag_search_picture_frame       (struct id3_tag*       tag,
                                                          enum id3_picture_type picture_type);
struct id3_frame*     id3_tag_search_frame               (struct id3_tag*       tag,
                                                          const char*           id);
char*                 id3_frame_get_text                 (struct id3_frame*     frame);
union id3_field*      id3_frame_get_binary_data          (struct id3_frame*     frame);
unsigned char*        id3_frame_get_picture              (struct id3_frame*     frame,
                                                          enum id3_picture_type picture_type,
                                                          int*                  length);
enum id3_picture_type id3_frame_get_picture_type         (struct id3_frame*     frame);
char*                 id3_frame_get_picture_description  (struct id3_frame*     frame);

#endif /* _ID3TAG_EXTRA_H */
