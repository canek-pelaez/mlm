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

noinst_DATA = vapi/config.vapi vapi/id3tag.vapi

EXTRA_DIST = $(noinst_DATA)

#SUBDIRS = po

dist-hook:
	cd ${top_srcdir} && git log --no-color --stat --name-only --date=short --abbrev-commit > ${srcdir}/ChangeLog
