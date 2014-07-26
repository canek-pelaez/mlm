AUTOMAKE_OPTIONS = subdir-objects

# global
AM_CPPFLAGS =					\
	-include config.h			\
	-DLOCALEDIR=\""$(localedir)"\"		\
	-DPKGDATADIR=\""$(pkgdatadir)"\"	\
	-DPKGLIBDIR=\""$(pkglibdir)"\"

COMMON_VALAFLAGS =				\
	--enable-experimental			\
	--target-glib=2.38			\
	--vapidir $(srcdir)/vapi 		\
	$(NULL)

# ====== libid3tag-x

noinst_LTLIBRARIES = id3tag-x/libid3tag-x.la
id3tag_x_libid3tag_x_la_SOURCES =		\
	id3tag-x/id3tag-x.c			\
	id3tag-x/id3tag-x.h			\
	$(NULL)

# ====== libmlm

noinst_LTLIBRARIES += src/libmlm.la

src_libmlm_la_SOURCES =				\
	src/genres.vala				\
	src/frame-id.vala			\
	src/file-tags.vala			\
	src/console-tools.vala			\
	$(NULL)

src_libmlm_la_VALAFLAGS =			\
	$(COMMON_VALAFLAGS)			\
	--vapi vapi/mlm.vapi			\
	--header src/mlm.h			\
	@GEE_PACKAGES@				\
	@ID3TAG_PACKAGES@			\
	$(NULL)

src_libmlm_la_CFLAGS =				\
	@GEE_CFLAGS@				\
	@ID3TAG_CFLAGS@				\
	-I$(srcdir)/id3tag-x			\
	-w					\
	$(NULL)

src_libmlm_la_LIBADD =				\
	@GEE_LIBS@				\
	@ID3TAG_LIBS@				\
	id3tag-x/libid3tag-x.la			\
	$(NULL)

# ====== mlm-verify

bin_PROGRAMS = src/mlm-verify

src_mlm_verify_SOURCES =			\
	src/verify.vala				\
	vapi/mlm.vapi				\
	$(NULL)

src_mlm_verify_VALAFLAGS =			\
	$(COMMON_VALAFLAGS)			\
	@ID3TAG_PACKAGES@			\
	@GEE_PACKAGES@				\
	$(NULL)

src_mlm_verify_CFLAGS =				\
	@ID3TAG_CFLAGS@				\
	@GEE_CFLAGS@				\
	-I$(srcdir)/id3tag-x			\
	-I$(srcdir)/src				\
	-w					\
	$(NULL)

src_mlm_verify_LDADD =				\
	@ID3TAG_LIBS@				\
	@GEE_LIBS@				\
	id3tag-x/libid3tag-x.la			\
	src/libmlm.la				\
	$(NULL)

# ====== mlm-analyze

bin_PROGRAMS += src/mlm-analyze

src_mlm_analyze_SOURCES =			\
	src/analyze.vala			\
	vapi/mlm.vapi				\
	$(NULL)

src_mlm_analyze_VALAFLAGS =			\
	$(COMMON_VALAFLAGS)			\
	@ID3TAG_PACKAGES@			\
	@GEE_PACKAGES@				\
	$(NULL)

src_mlm_analyze_CFLAGS =			\
	@ID3TAG_CFLAGS@				\
	@GEE_CFLAGS@				\
	-I$(srcdir)/src				\
	-I$(srcdir)/id3tag-x			\
	-w					\
	$(NULL)

src_mlm_analyze_LDADD =				\
	@ID3TAG_LIBS@				\
	@GEE_LIBS@				\
	id3tag-x/libid3tag-x.la			\
	src/libmlm.la				\
	$(NULL)

# ====== mlm-tags

bin_PROGRAMS += src/mlm-tags

src_mlm_tags_SOURCES =				\
	src/tags.vala				\
	vapi/mlm.vapi				\
	$(NULL)

src_mlm_tags_VALAFLAGS =			\
	$(COMMON_VALAFLAGS)			\
	@GEE_PACKAGES@				\
	$(NULL)

src_mlm_tags_CFLAGS =				\
	@GEE_CFLAGS@				\
	-I$(srcdir)/id3tag-x			\
	-I$(srcdir)/src				\
	-w					\
	$(NULL)

src_mlm_tags_LDADD =				\
	@GEE_LIBS@				\
	id3tag-x/libid3tag-x.la			\
	src/libmlm.la				\
	$(NULL)

# ====== mlm-encoder

bin_PROGRAMS += src/mlm-encoder

src_mlm_encoder_SOURCES =			\
	src/encoder.vala			\
	vapi/mlm.vapi				\
	$(NULL)

src_mlm_encoder_VALAFLAGS =			\
	$(COMMON_VALAFLAGS)			\
	@GEE_PACKAGES@				\
	@GSTREAMER_PACKAGES@			\
	@GTK_PACKAGES@				\
	--pkg config				\
	$(NULL)

src_mlm_encoder_CFLAGS =			\
	@GEE_CFLAGS@				\
	@GSTREAMER_CFLAGS@			\
	@GTK_CFLAGS@				\
	-I$(srcdir)/src				\
	-w					\
	$(NULL)

src_mlm_encoder_LDADD =				\
	@GEE_LIBS@				\
	@GSTREAMER_LIBS@			\
	@GTK_LIBS@				\
	src/libmlm.la				\
	$(NULL)

# ====== UI files

uidir = $(pkgdatadir)
ui_DATA =					\
	data/mlm-encoder.ui			\
	data/nodisc.jpg				\
	data/person.jpg				\
	$(NULL)

data_desktopdir = $(datadir)/applications
data_desktop_DATA = data/mlm-encoder.desktop

data_iconsdir = $(datadir)/icons/hicolor/scalable/apps
data_icons_DATA = data/mlm-encoder.svg

noinst_DATA =					\
	vapi/config.vapi			\
	vapi/id3tag.vapi			\
	vapi/mlm.vapi
	$(NULL)

EXTRA_DIST =					\
	$(noinst_DATA)				\
	$(ui_DATA)				\
	$(data_desktop_DATA)			\
	$(data_icons_DATA)			\
	$(NULL)

DISTCLEANFILES =				\
	src/mlm.h				\
	vapi/mlm.vapi				\
	$(NULL)

SUBDIRS = po

dist-hook:
	cd ${top_srcdir} &&			\
	git log --no-color --stat --name-only	\
		--date=short --abbrev-commit	\
		> ${srcdir}/ChangeLog
