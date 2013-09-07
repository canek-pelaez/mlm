AUTOMAKE_OPTIONS = subdir-objects

# global
AM_CPPFLAGS =					\
	-include config.h			\
	-DLOCALEDIR=\""$(localedir)"\"		\
	-DPKGDATADIR=\""$(pkgdatadir)"\"	\
	-DPKGLIBDIR=\""$(pkglibdir)"\"

AM_VALAFLAGS =					\
	--vapidir=$(srcdir)/vapi 		\
	--pkg config --pkg id3tag		\
	@MLM_PACKAGES@

# libid3tag-extra.a
noinst_LIBRARIES = id3tag-extra/libid3tag-extra.a
id3tag_extra_libid3tag_extra_a_SOURCES =	\
	id3tag-extra/id3tag-extra.c		\
	id3tag-extra/id3tag-extra.h

# mlm-fix-pictures
bin_PROGRAMS = src/mlm-fix-pictures
src_mlm_fix_pictures_SOURCES = src/mlm-fix-pictures.vala
src_mlm_fix_pictures_CFLAGS = $(MLM_CFLAGS) -I$(srcdir)/id3tag-extra
src_mlm_fix_pictures_LDADD = $(MLM_LIBS) id3tag-extra/libid3tag-extra.a

# mlm-fix-duplicated-pictures
bin_PROGRAMS += src/mlm-fix-duplicated-pictures
src_mlm_fix_duplicated_pictures_SOURCES = src/mlm-fix-duplicated-pictures.vala
src_mlm_fix_duplicated_pictures_CFLAGS = $(MLM_CFLAGS) -I$(srcdir)/id3tag-extra
src_mlm_fix_duplicated_pictures_LDADD = $(MLM_LIBS) id3tag-extra/libid3tag-extra.a

# mlm-tags
bin_PROGRAMS += src/mlm-tags
src_mlm_tags_SOURCES =	 			\
	src/mlm-genres.vala			\
	src/mlm-file-tags.vala			\
	src/mlm-tags.vala
src_mlm_tags_CFLAGS = $(MLM_CFLAGS) -I$(srcdir)/id3tag-extra
src_mlm_tags_LDADD = $(MLM_LIBS) id3tag-extra/libid3tag-extra.a

noinst_DATA = vapi/config.vapi vapi/id3tag.vapi

EXTRA_DIST = $(noinst_DATA)

#SUBDIRS = po

dist-hook:
	cd ${top_srcdir} && git log --no-color --stat --name-only --date=short --abbrev-commit > ${srcdir}/ChangeLog
