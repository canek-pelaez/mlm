#include <id3tag.h>
#include <stdlib.h>
#include <string.h>
#include "id3tag-extra.h"

struct id3_frame*
id3_tag_search_picture_frame(struct id3_tag*       tag,
                             enum id3_picture_type picture_type)
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
                        if (field->number.value == picture_type)
                                return frame;
                }
        }
        return NULL;
}

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

unsigned char*
id3_frame_get_picture(struct id3_frame*     frame,
                      enum id3_picture_type picture_type,
                      int*                  length)
{
        int j, l = -1;
        long pt = -1;
        unsigned char* data = NULL;
        printf("A2\n");
        for (j = 0; j < frame->nfields; j++) {
                printf("A3\n");
                union id3_field* field = id3_frame_field(frame, j);
                if (field->type == ID3_FIELD_TYPE_INT8) {
                        printf("A4\n");
                        pt = field->number.value;
                } else if (field->type == ID3_FIELD_TYPE_BINARYDATA) {
                        printf("A5\n");
                        data = field->binary.data;
                        l = field->binary.length;
                }
        }
        printf("A6\n");
        if (pt == picture_type && data != NULL) {
                printf("A7\n");
                *length = l;
                printf("A8\n");
                return data;
        }
        printf("A9\n");
        return NULL;
}
