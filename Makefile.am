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
	@MUSICCOLLECTION_PACKAGES@

# libid3tag-extra.a
noinst_LIBRARIES = id3tag-extra/libid3tag-extra.a
id3tag_extra_libid3tag_extra_a_SOURCES =	\
	id3tag-extra/id3tag-extra.c		\
	id3tag-extra/id3tag-extra.h

# music-collection-fix-pictures
bin_PROGRAMS = src/music-collection-fix-pictures

src_music_collection_fix_pictures_SOURCES = src/music-collection-fix-pictures.vala
src_music_collection_fix_pictures_CFLAGS = $(MUSICCOLLECTION_CFLAGS) -I$(srcdir)/id3tag-extra
src_music_collection_fix_pictures_LDADD = $(MUSICCOLLECTION_LIBS) id3tag-extra/libid3tag-extra.a

noinst_DATA = vapi/config.vapi vapi/id3tag.vapi

EXTRA_DIST = $(noinst_DATA)

#SUBDIRS = po

dist-hook:
	cd ${top_srcdir} && git log --no-color --stat --name-only --date=short --abbrev-commit > ${srcdir}/ChangeLog
