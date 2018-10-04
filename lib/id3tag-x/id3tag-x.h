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

#include <id3tag.h>

#ifndef _ID3TAG_EXTRA_H
#define _ID3TAG_EXTRA_H

/**
 * Enumeration of types of picture.
 * http://id3lib.sourceforge.net/id3/id3v2.4.0-structure.txt
 */
enum id3_picture_type {
        ID3_PICTURETYPE_OTHER         = 0,  /* Other */
        ID3_PICTURETYPE_PNG32ICON     = 1,  /* 32x32 pixels 'file icon' (PNG only) */
        ID3_PICTURETYPE_OTHERICON     = 2,  /* Other file icon */
        ID3_PICTURETYPE_COVERFRONT    = 3,  /* Cover (front) */
        ID3_PICTURETYPE_COVERBACK     = 4,  /* Cover (back) */
        ID3_PICTURETYPE_LEAFLETPAGE   = 5,  /* Leaflet page */
        ID3_PICTURETYPE_MEDIA         = 6,  /* Media (e.g. lable side of CD) */
        ID3_PICTURETYPE_LEADARTIST    = 7,  /* Lead artist/lead performer/soloist */
        ID3_PICTURETYPE_ARTIST        = 8,  /* Artist/performer */
        ID3_PICTURETYPE_CONDUCTOR     = 9,  /* Conductor */
        ID3_PICTURETYPE_BAND          = 10, /* Band/Orchestra */
        ID3_PICTURETYPE_COMPOSER      = 11, /* Composer */
        ID3_PICTURETYPE_LYRICIST      = 12, /* Lyricist/text writer */
        ID3_PICTURETYPE_REC_LOCATION  = 13, /* Recording Location */
        ID3_PICTURETYPE_RECORDING     = 14, /* During recording */
        ID3_PICTURETYPE_PERFORMANCE   = 15, /* During performance */
        ID3_PICTURETYPE_VIDEO         = 16, /* Movie/video screen capture */
        ID3_PICTURETYPE_FISH          = 17, /* A bright coloured fish */
        ID3_PICTURETYPE_ILLUSTRATION  = 18, /* Illustration */
        ID3_PICTURETYPE_ARTISTLOGO    = 19, /* Band/artist logotype */
        ID3_PICTURETYPE_PUBLISHERLOGO = 20  /* Publisher/Studio logotype */
};

/**
 * Searches a frame by id.
 * @param tag the id3 tag.
 * @param id the id of the frame.
 * @return the frame with the given id, or NULL if not found.
 */
struct id3_frame*     id3_tag_search_frame               (struct id3_tag*       tag,
                                                          const char*           id);

/**
 * Searches a picture frame by type.
 * @param tag the id3 tag.
 * @param ptype the picture type.
 * @return the frame with the given type, or NULL if not found.
 */
struct id3_frame*     id3_tag_search_picture_frame       (struct id3_tag*       tag,
                                                          enum id3_picture_type ptype);

/**
 * Creates a text frame.
 * @param tag the id3 tag.
 * @param id the id of the new text frame.
 * @return a newly created text frame with the given id.
 */
struct id3_frame*     id3_tag_create_text_frame          (struct id3_tag*       tag,
                                                          const char*           id);

/**
 * Creates a comment frame.
 * @param tag the id3 tag.
 * @param lang the language of the new comment frame.
 * @return a newly created comment frame with the given language.
 */
struct id3_frame*     id3_tag_create_comment_frame       (struct id3_tag*       tag,
                                                          const char*           lang);

/**
 * Creates a picture frame.
 * @param tag the id3 tag.
 * @param ptype the picture type of the new picture frame.
 * @return a newly created picture frame with the given picture type.
 */
struct id3_frame*     id3_tag_create_picture_frame       (struct id3_tag*       tag,
                                                          enum id3_picture_type ptype);

/**
 * Returns the text of an id3 frame.
 * @param frame the id3 frame.
 * @return the text of the id3 frame, or NULL if the frame has no text.
 */
char*                 id3_frame_get_text                 (struct id3_frame*     frame);

/**
 * Sets the text of an id3 frame.
 * @param frame the id3 frame.
 * @param text the new text of the id3 frame.
 */
void                  id3_frame_set_text                 (struct id3_frame*     frame,
                                                          const char*           text);

/**
 * Returns the comment text of an id3 frame.
 * @param frame the id3 frame.
 * @return the comment text of the id3 frame, or NULL if the frame is not text.
 */
char*                 id3_frame_get_comment_text         (struct id3_frame*     frame);

/**
 * Sets the comment text of an id3 frame.
 * @param frame the id3 frame.
 * @param text the new comment text of the id3 frame.
 */
void                  id3_frame_set_comment_text         (struct id3_frame*     frame,
                                                          const char*           text);

/**
 * Returns the picture data of an id3 frame.
 * @param frame the id3 frame.
 * @param ptype the picture type.
 * @param[out] length the picture data length.
 * @return the picture data, or NULL if there is no picture data.
 */
unsigned char*        id3_frame_get_picture              (struct id3_frame*     frame,
                                                          enum id3_picture_type ptype,
                                                          int*                  length);

/**
 * Sets the picture data of an id3 frame.
 * @param frame the id3 frame.
 * @param bytes the new picture data.
 * @param length the new picture data length.
 */
void                  id3_frame_set_picture              (struct id3_frame*     frame,
                                                          unsigned char*        bytes,
                                                          unsigned int          length,
                                                          const char*           desc);

/**
 * Returns the picture description of an id3 frame.
 * @param frame the id3 frame.
 * @return the picture description, or NULL if there is no picture description.
 */
char*                 id3_frame_get_picture_description  (struct id3_frame*     frame);

/**
 * Sets the picture description of an id3 frame.
 * @param frame the id3 frame.
 * @param desc the new picture description.
 */
void                  id3_frame_set_picture_description  (struct id3_frame*     frame,
                                                          const char*           desc);

/**
 * Returns the binary data of an id3 frame.
 * @param frame the id3 frame.
 * @return the binary data of an id3 frame, or NULL if there is no binary data.
 */
union id3_field*      id3_frame_get_binary_data          (struct id3_frame*     frame);

/**
 * Returns the picture type of an id3 frame.
 * @param frame the id3 frame.
 * @return the picture type of the frame.
 */
enum id3_picture_type id3_frame_get_picture_type         (struct id3_frame*     frame);

#endif /* _ID3TAG_EXTRA_H */
