AUTOMAKE_OPTIONS = subdir-objects

# global
INCLUDES =					\
	-include config.h			\
	-DLOCALEDIR=\""$(localedir)"\"		\
	-DPKGDATADIR=\""$(pkgdatadir)"\"	\
	-DPKGLIBDIR=\""$(pkglibdir)"\"

VALAFLAGS =					\
	--vapidir=$(srcdir)/vapi 		\
	--pkg config --pkg id3tag		\
	@MUSICCOLLECTION_PACKAGES@

# music-collection-fix-pictures
bin_PROGRAMS = src/music-collection-fix-pictures

src_music_collection_fix_pictures_SOURCES = src/music-collection-fix-pictures.vala
src_music_collection_fix_pictures_CFLAGS = $(MUSICCOLLECTION_CFLAGS) -I$(srcdir)/src
src_music_collection_fix_pictures_LDADD = $(MUSICCOLLECTION_LIBS)

noinst_DATA = vapi/config.vapi vapi/id3tag.vapi

EXTRA_DIST = $(noinst_DATA)

#SUBDIRS = po

dist-hook:
	cd ${top_srcdir} && git log --no-color --stat --name-only --date=short --abbrev-commit > ${srcdir}/ChangeLog
