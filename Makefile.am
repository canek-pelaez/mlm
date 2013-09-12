AUTOMAKE_OPTIONS = subdir-objects

# global
AM_CPPFLAGS =					\
	-include config.h			\
	-DLOCALEDIR=\""$(localedir)"\"		\
	-DPKGDATADIR=\""$(pkgdatadir)"\"	\
	-DPKGLIBDIR=\""$(pkglibdir)"\"

COMMON_VALAFLAGS =				\
	--enable-experimental			\
	--vapidir=$(srcdir)/vapi 		\
	--pkg config --pkg id3tag		\
	@MLM_PACKAGES@

ID3TAG_EXTRA_CFLAGS = -I$(srcdir)/id3tag-extra
ID3TAG_EXTRA_LIBS = id3tag-extra/libid3tag-extra.la

LIBMLM_VALAFLAGS = --pkg mlm
LIBMLM_CFLAGS = -I$(srcdir)/src
LIBMLM_LIBS = src/libmlm.la

# libid3tag-extra.a
noinst_LTLIBRARIES = id3tag-extra/libid3tag-extra.la
id3tag_extra_libid3tag_extra_la_SOURCES =	\
	id3tag-extra/id3tag-extra.c		\
	id3tag-extra/id3tag-extra.h

# libmlm.la
noinst_LTLIBRARIES += src/libmlm.la
src_libmlm_la_SOURCES =				\
	src/mlm-genres.vala			\
	src/mlm-frame-id.vala			\
	src/mlm-file-tags.vala
src_libmlm_la_VALAFLAGS =			\
	--vapi=vapi/mlm.vapi			\
	-H src/mlm.h				\
	$(COMMON_VALAFLAGS)
src_libmlm_la_CFLAGS = $(MLM_CFLAGS) $(ID3TAG_EXTRA_CFLAGS)
src_libmlm_la_LIBADD = $(MLM_LIBS) $(ID3TAG_EXTRA_LIBS)

# mlm-verify
bin_PROGRAMS = src/mlm-verify
src_mlm_verify_SOURCES = src/mlm-verify.vala
src_mlm_verify_VALAFLAGS = $(COMMON_VALAFLAGS) $(LIBMLM_VALAFLAGS)
src_mlm_verify_CFLAGS = $(MLM_CFLAGS) $(LIBMLM_CFLAGS) $(ID3TAG_EXTRA_CFLAGS)
src_mlm_verify_LDADD = $(MLM_LIBS) $(LIBMLM_LIBS) $(ID3TAG_EXTRA_LIBS)

# mlm-tags
bin_PROGRAMS += src/mlm-tags
src_mlm_tags_VALAFLAGS = $(COMMON_VALAFLAGS) $(LIBMLM_VALAFLAGS)
src_mlm_tags_SOURCES = src/mlm-tags.vala
src_mlm_tags_CFLAGS = $(MLM_CFLAGS) $(ID3TAG_EXTRA_CFLAGS) $(LIBMLM_CFLAGS)
src_mlm_tags_LDADD = $(MLM_LIBS) $(ID3TAG_EXTRA_LIBS) $(LIBMLM_LIBS)

# mlm-encoder
bin_PROGRAMS += src/mlm-encoder
src_mlm_encoder_SOURCES = src/mlm-encoder.vala
src_mlm_encoder_VALAFLAGS = $(COMMON_VALAFLAGS) $(LIBMLM_VALAFLAGS) @GTK_PACKAGES@
src_mlm_encoder_CFLAGS = $(MLM_CFLAGS) $(GTK_CFLAGS) $(LIBMLM_CFLAGS)
src_mlm_encoder_LDADD = $(MLM_LIBS) $(GTK_LIBS) $(LIBMLM_LIBS)

uidir = $(pkgdatadir)
ui_DATA = data/mlm-encoder.ui data/nodisc.jpg data/person.jpg

data_desktopdir = $(datadir)/applications
data_desktop_DATA = data/mlm-encoder.desktop

data_iconsdir = $(datadir)/icons/hicolor/scalable/apps
data_icons_DATA = data/mlm-encoder.svg

noinst_DATA = vapi/config.vapi vapi/id3tag.vapi vapi/mlm.vapi

EXTRA_DIST = $(noinst_DATA) $(ui_DATA) $(data_desktop_DATA) $(data_icons_DATA) src/mlm.h

DISTCLEANFILES = src/mlm.h vapi/mlm.vapi

SUBDIRS = po

dist-hook:
	cd ${top_srcdir} && git log --no-color --stat --name-only --date=short --abbrev-commit > ${srcdir}/ChangeLog
