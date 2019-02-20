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

#include <id3tag.h>
#include <stdlib.h>
#include <string.h>
#include "id3tag-x.h"

/* Searches a frame by id. */
struct id3_frame*
id3_tag_search_frame(struct id3_tag* tag,
                     const char*     id)
{
        int i;
        for (i = 0; i < tag->nframes; i++) {
                struct id3_frame* frame = tag->frames[i];
                if (!strcmp(frame->id, id))
                        return frame;
        }
        return NULL;
}

/* Searches a picture frame by type. */
struct id3_frame*
id3_tag_search_picture_frame(struct id3_tag*       tag,
                             enum id3_picture_type ptype)
{
        int i, j;
        for (i = 0; i < tag->nframes; i++) {
                struct id3_frame* frame = tag->frames[i];
                if (strcmp(frame->id, "APIC"))
                        continue;
                for (j = 0; j < frame->nfields; j++) {
                        union id3_field* field = id3_frame_field(frame, j);
                        if (field->type != ID3_FIELD_TYPE_INT8)
                                continue;
                        if (field->number.value == ptype)
                                return frame;
                }
        }
        return NULL;
}

/* Creates a text frame.*/
struct id3_frame*
id3_tag_create_text_frame(struct id3_tag* tag,
                          const char*     id)
{
        int i;
        struct id3_frame* frame = id3_frame_new(id);
        for (i = 0; i < frame->nfields; i++) {
                union id3_field* field = id3_frame_field(frame, i);
                if (field->type == ID3_FIELD_TYPE_TEXTENCODING)
                        id3_field_settextencoding(field, ID3_FIELD_TEXTENCODING_UTF_8);
        }
        return frame;
}

/* Creates a comment frame. */
struct id3_frame*
id3_tag_create_comment_frame(struct id3_tag* tag,
                             const char*     lang)
{
        int i;
        struct id3_frame* frame = id3_frame_new("COMM");
        for (i = 0; i < frame->nfields; i++) {
                union id3_field* field = id3_frame_field(frame, i);
                if (field->type == ID3_FIELD_TYPE_TEXTENCODING)
                        id3_field_settextencoding(field, ID3_FIELD_TEXTENCODING_UTF_8);
                if (field->type == ID3_FIELD_TYPE_LANGUAGE)
                        id3_field_setlanguage(field, lang);
        }
        return frame;
}

/* Creates a picture frame. */
struct id3_frame*
id3_tag_create_picture_frame(struct id3_tag*       tag,
                             enum id3_picture_type ptype)
{
        int i;
        struct id3_frame* frame = id3_frame_new("APIC");
        for (i = 0; i < frame->nfields; i++) {
                union id3_field* field = id3_frame_field(frame, i);
                if (field->type == ID3_FIELD_TYPE_TEXTENCODING)
                        id3_field_settextencoding(field, ID3_FIELD_TEXTENCODING_UTF_8);
                if (field->type == ID3_FIELD_TYPE_LATIN1)
                        id3_field_setlatin1(field, (unsigned char*)"image/jpeg");
                if (field->type == ID3_FIELD_TYPE_INT8)
                        field->number.value = ptype;
                if (field->type == ID3_FIELD_TYPE_STRING) {
                        id3_ucs4_t* s = id3_utf8_ucs4duplicate((id3_utf8_t*)"");
                        id3_field_setstring(field, s);
                        free(s);
                }
        }
        return frame;
}

/* Returns the text of a id3 frame. */
char*
id3_frame_get_text(struct id3_frame* frame)
{
        int i, j;
        for (i = 0; i < frame->nfields; i++) {
                union id3_field* field = id3_frame_field(frame, i);
                if (field->type != ID3_FIELD_TYPE_STRINGLIST)
                        continue;
                for (j = 0; j < field->stringlist.nstrings; j++) {
                        const id3_ucs4_t * s = id3_field_getstrings(field, j);
                        id3_utf8_t* us = id3_ucs4_utf8duplicate(s);
                        return (char*)us;
                }
        }
        return NULL;
}

/* Sets the text of an id3 frame. */
void
id3_frame_set_text(struct id3_frame* frame,
                   const char*       text)
{
        int i;
        for (i = 0; i < frame->nfields; i++) {
                union id3_field* field = id3_frame_field(frame, i);
                if (field->type == ID3_FIELD_TYPE_TEXTENCODING)
                        id3_field_settextencoding(field, ID3_FIELD_TEXTENCODING_UTF_8);
                if (field->type == ID3_FIELD_TYPE_STRINGLIST) {
                        id3_ucs4_t* ucs[] = {
                                id3_utf8_ucs4duplicate((id3_utf8_t*)text)
                        };
                        id3_field_setstrings(field, 1, ucs);
                        free(ucs[0]);
                }
        }
}

/* Returns the comment text of an id3 frame. */
char*
id3_frame_get_comment_text(struct id3_frame* frame)
{
        int i;
        for (i = 0; i < frame->nfields; i++) {
                union id3_field* field = id3_frame_field(frame, i);
                if (field->type != ID3_FIELD_TYPE_STRINGFULL)
                        continue;
                const id3_ucs4_t* s = id3_field_getfullstring(field);
                id3_utf8_t* us = id3_ucs4_utf8duplicate(s);
                return (char*)us;
        }
        return NULL;
}

/* Sets the comment text of an id3 frame. */
void
id3_frame_set_comment_text(struct id3_frame* frame,
                           const char*       text)
{
        int i;
        for (i = 0; i < frame->nfields; i++) {
                union id3_field* field = id3_frame_field(frame, i);
                if (field->type != ID3_FIELD_TYPE_STRINGFULL)
                        continue;
                id3_ucs4_t* ucs = id3_utf8_ucs4duplicate((id3_utf8_t*)text);
                id3_field_setfullstring(field, ucs);
                free(ucs);
        }
}

/* Returns the picture data of an id3 frame. */
unsigned char*
id3_frame_get_picture(struct id3_frame*     frame,
                      enum id3_picture_type ptype,
                      int*                  length)
{
        int i, l = -1;
        long pt = -1;
        unsigned char* data = NULL;
        for (i = 0; i < frame->nfields; i++) {
                union id3_field* field = id3_frame_field(frame, i);
                if (field->type == ID3_FIELD_TYPE_INT8) {
                        pt = field->number.value;
                } else if (field->type == ID3_FIELD_TYPE_BINARYDATA) {
                        data = field->binary.data;
                        l = field->binary.length;
                }
        }
        if (pt == ptype && data != NULL) {
                *length = l;
                return data;
        }
        return NULL;
}

/* Sets the picture data of an id3 frame. */
void
id3_frame_set_picture(struct id3_frame* frame,
                      unsigned char*    bytes,
                      unsigned int      length,
                      const char*       desc)
{
        int i;
        for (i = 0; i < frame->nfields; i++) {
                union id3_field* field = id3_frame_field(frame, i);
                if (field->type == ID3_FIELD_TYPE_STRING) {
                        id3_ucs4_t* s = id3_utf8_ucs4duplicate((id3_utf8_t*)desc);
                        id3_field_setstring(field, s);
                        free(s);
                }
                if (field->type == ID3_FIELD_TYPE_BINARYDATA)
                        id3_field_setbinarydata(field, bytes, length);
        }
}

/* Returns the picture description of an id3 frame. */
char*
id3_frame_get_picture_description(struct id3_frame* frame)
{
        int i;
        for (i = 0; i < frame->nfields; i++) {
                union id3_field* field = id3_frame_field(frame, i);
                if (field->type == ID3_FIELD_TYPE_STRING) {
                        return (char*)id3_ucs4_utf8duplicate(id3_field_getstring(field));
                }
        }
        return NULL;
}

/* Sets the picture description of an id3 frame. */
void
id3_frame_set_picture_description(struct id3_frame* frame,
                                  const char*       desc)
{
        int i;
        for (i = 0; i < frame->nfields; i++) {
                union id3_field* field = id3_frame_field(frame, i);
                if (field->type == ID3_FIELD_TYPE_STRING) {
                        id3_ucs4_t* s = id3_utf8_ucs4duplicate((id3_utf8_t*)desc);
                        id3_field_setstring(field, s);
                        free(s);
                }
        }
}

/* Returns the binary data of an id3 frame. */
union id3_field*
id3_frame_get_binary_field(struct id3_frame* frame)
{
        int i;
        for (i = 0; i < frame->nfields; i++) {
                union id3_field* field = id3_frame_field(frame, i);
                if (field->type != ID3_FIELD_TYPE_BINARYDATA)
                        continue;
                return field;
        }
        return NULL;
}

/* Returns the picture type of an id3 frame. */
enum id3_picture_type
id3_frame_get_picture_type(struct id3_frame* frame)
{
        int i;
        long pt = -1;
        for (i = 0; i < frame->nfields; i++) {
                union id3_field* field = id3_frame_field(frame, i);
                if (field->type == ID3_FIELD_TYPE_INT8) {
                        if (pt != -1)
                                return -1;
                        pt = field->number.value;
                }
        }
        return pt;
}
