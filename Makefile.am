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

noinst_LTLIBRARIES += mlm/libmlm.la

mlm_libmlm_la_SOURCES =				\
	mlm/genres.vala				\
	mlm/frame-id.vala			\
	mlm/file-tags.vala			\
	mlm/console-tools.vala			\
	$(NULL)

mlm_libmlm_la_VALAFLAGS =			\
	$(COMMON_VALAFLAGS)			\
	--vapi vapi/mlm.vapi			\
	--header mlm/mlm.h			\
	@GEE_PACKAGES@				\
	@ID3TAG_PACKAGES@			\
	$(NULL)

mlm_libmlm_la_CFLAGS =				\
	@GEE_CFLAGS@				\
	@ID3TAG_CFLAGS@				\
	-I$(srcdir)/id3tag-x			\
	-w					\
	$(NULL)

mlm_libmlm_la_LIBADD =				\
	@GEE_LIBS@				\
	@ID3TAG_LIBS@				\
	id3tag-x/libid3tag-x.la			\
	$(NULL)

# ====== mlm-verify

bin_PROGRAMS = verify/mlm-verify

verify_mlm_verify_SOURCES =			\
	verify/verify.vala			\
	vapi/mlm.vapi				\
	$(NULL)

verify_mlm_verify_VALAFLAGS =			\
	$(COMMON_VALAFLAGS)			\
	@ID3TAG_PACKAGES@			\
	@GEE_PACKAGES@				\
	$(NULL)

verify_mlm_verify_CFLAGS =			\
	@ID3TAG_CFLAGS@				\
	@GEE_CFLAGS@				\
	-I$(srcdir)/id3tag-x			\
	-I$(srcdir)/mlm				\
	-w					\
	$(NULL)

verify_mlm_verify_LDADD =			\
	@ID3TAG_LIBS@				\
	@GEE_LIBS@				\
	id3tag-x/libid3tag-x.la			\
	mlm/libmlm.la				\
	$(NULL)

# ====== mlm-analyze

bin_PROGRAMS += analyze/mlm-analyze

analyze_mlm_analyze_SOURCES =			\
	analyze/analyze.vala			\
	vapi/mlm.vapi				\
	$(NULL)

analyze_mlm_analyze_VALAFLAGS =			\
	$(COMMON_VALAFLAGS)			\
	@ID3TAG_PACKAGES@			\
	@GEE_PACKAGES@				\
	$(NULL)

analyze_mlm_analyze_CFLAGS =			\
	@ID3TAG_CFLAGS@				\
	@GEE_CFLAGS@				\
	-I$(srcdir)/id3tag-x			\
	-I$(srcdir)/mlm			\
	-w					\
	$(NULL)

analyze_mlm_analyze_LDADD =			\
	@ID3TAG_LIBS@				\
	@GEE_LIBS@				\
	id3tag-x/libid3tag-x.la			\
	mlm/libmlm.la				\
	$(NULL)

# ====== mlm-tags

bin_PROGRAMS += tags/mlm-tags

tags_mlm_tags_SOURCES =				\
	tags/tags.vala				\
	vapi/mlm.vapi				\
	$(NULL)

tags_mlm_tags_VALAFLAGS =			\
	$(COMMON_VALAFLAGS)			\
	@GEE_PACKAGES@				\
	$(NULL)

tags_mlm_tags_CFLAGS =				\
	@GEE_CFLAGS@				\
	-I$(srcdir)/id3tag-x			\
	-I$(srcdir)/mlm				\
	-w					\
	$(NULL)

tags_mlm_tags_LDADD =				\
	@GEE_LIBS@				\
	id3tag-x/libid3tag-x.la			\
	mlm/libmlm.la				\
	$(NULL)

# ====== mlm-encoder

bin_PROGRAMS += encoder/mlm-encoder

encoder_mlm_encoder_SOURCES =			\
	encoder/encoder.vala			\
	vapi/mlm.vapi				\
	$(NULL)

encoder_mlm_encoder_VALAFLAGS =			\
	$(COMMON_VALAFLAGS)			\
	@GEE_PACKAGES@				\
	@GSTREAMER_PACKAGES@			\
	@GTK_PACKAGES@				\
	--pkg config				\
	$(NULL)

encoder_mlm_encoder_CFLAGS =			\
	@GEE_CFLAGS@				\
	@GSTREAMER_CFLAGS@			\
	@GTK_CFLAGS@				\
	-I$(srcdir)/mlm				\
	-w					\
	$(NULL)

encoder_mlm_encoder_LDADD =			\
	@GEE_LIBS@				\
	@GSTREAMER_LIBS@			\
	@GTK_LIBS@				\
	mlm/libmlm.la				\
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
