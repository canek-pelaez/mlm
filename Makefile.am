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

# ====== gresource
gresource_file = $(top_srcdir)/data/mlm.gresource.xml
resource_files = 				\
	$(top_srcdir)/data/mlm.ui		\
	$(top_srcdir)/data/mlm.css		\
	$(NULL)

mlm/resources.c: $(gresource_file) $(resource_files)
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) 	\
		--target=$@			\
		--sourcedir=$(top_srcdir)/data	\
		--generate-source $<

# ====== libid3tag-x

noinst_LTLIBRARIES = id3tag-x/libid3tag-x.la
id3tag_x_libid3tag_x_la_SOURCES =		\
	id3tag-x/id3tag-x.c			\
	id3tag-x/id3tag-x.h			\
	$(NULL)

# ====== libmlm

noinst_LTLIBRARIES += libmlm/libmlm.la

libmlm_libmlm_la_SOURCES =			\
	libmlm/genres.vala			\
	libmlm/frame-id.vala			\
	libmlm/file-tags.vala			\
	libmlm/console-tools.vala		\
	$(NULL)

libmlm_libmlm_la_VALAFLAGS =			\
	$(COMMON_VALAFLAGS)			\
	--vapi vapi/mlm.vapi			\
	--header libmlm/mlm.h			\
	@GEE_PACKAGES@				\
	@ID3TAG_PACKAGES@			\
	$(NULL)

libmlm_libmlm_la_CFLAGS =			\
	@GEE_CFLAGS@				\
	@ID3TAG_CFLAGS@				\
	-I$(srcdir)/id3tag-x			\
	-w					\
	$(NULL)

libmlm_libmlm_la_LIBADD =			\
	@GEE_LIBS@				\
	@ID3TAG_LIBS@				\
	id3tag-x/libid3tag-x.la			\
	$(NULL)

# ====== mlm

bin_PROGRAMS = mlm/mlm

#	mlm/encoder.vala

mlm_mlm_SOURCES =				\
	mlm/application-window.vala		\
	mlm/application.vala			\
	mlm/main.vala				\
	mlm/resources.c				\
	vapi/mlm.vapi				\
	$(NULL)

#	@GSTREAMER_PACKAGES@

mlm_mlm_VALAFLAGS =				\
	$(COMMON_VALAFLAGS)			\
	@GEE_PACKAGES@				\
	@GTK_PACKAGES@				\
	--pkg config				\
	--gresources $(gresource_file)		\
	$(NULL)

#	@GSTREAMER_CFLAGS@

mlm_mlm_CFLAGS =				\
	@GEE_CFLAGS@				\
	@GTK_CFLAGS@				\
	-I$(srcdir)/libmlm			\
	-w					\
	$(NULL)

#	@GSTREAMER_LIBS@

mlm_mlm_LDADD =					\
	@GEE_LIBS@				\
	@GTK_LIBS@				\
	libmlm/libmlm.la			\
	$(NULL)

# ====== mlm-verify

bin_PROGRAMS += verify/mlm-verify

verify_mlm_verify_SOURCES =			\
	verify/verify.vala			\
	vapi/mlm.vapi				\
	$(NULL)

verify_mlm_verify_VALAFLAGS =			\
	$(COMMON_VALAFLAGS)			\
	@ID3TAG_PACKAGES@			\
	@GEE_PACKAGES@				\
	@GIO_PACKAGES@				\
	@GDK_PIXBUF_PACKAGES@			\
	$(NULL)

verify_mlm_verify_CFLAGS =			\
	@ID3TAG_CFLAGS@				\
	@GEE_CFLAGS@				\
	@GIO_CFLAGS@				\
	@GDK_PIXBUF_CFLAGS@			\
	-I$(srcdir)/id3tag-x			\
	-I$(srcdir)/libmlm			\
	-w					\
	$(NULL)

verify_mlm_verify_LDADD =			\
	@ID3TAG_LIBS@				\
	@GEE_LIBS@				\
	@GIO_LIBS@				\
	@GDK_PIXBUF_LIBS@			\
	id3tag-x/libid3tag-x.la			\
	libmlm/libmlm.la			\
	$(NULL)

# ====== mlm-copy-tags

bin_PROGRAMS += copy-tags/mlm-copy-tags

copy_tags_mlm_copy_tags_SOURCES =		\
	copy-tags/copy-tags.vala		\
	vapi/mlm.vapi				\
	$(NULL)

copy_tags_mlm_copy_tags_VALAFLAGS =		\
	$(COMMON_VALAFLAGS)			\
	@GLIB_PACKAGES@				\
	@ID3TAG_PACKAGES@			\
	$(NULL)

copy_tags_mlm_copy_tags_CFLAGS =		\
	@GLIB_CFLAGS@				\
	@ID3TAG_CFLAGS@				\
	-I$(srcdir)/id3tag-x			\
	-I$(srcdir)/libmlm			\
	-w					\
	$(NULL)

copy_tags_mlm_copy_tags_LDADD =			\
	@GLIB_LIBS@				\
	@ID3TAG_LIBS@				\
	id3tag-x/libid3tag-x.la			\
	libmlm/libmlm.la			\
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
	-I$(srcdir)/libmlm			\
	-w					\
	$(NULL)

analyze_mlm_analyze_LDADD =			\
	@ID3TAG_LIBS@				\
	@GEE_LIBS@				\
	id3tag-x/libid3tag-x.la			\
	libmlm/libmlm.la			\
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
	-I$(srcdir)/libmlm			\
	-w					\
	$(NULL)

tags_mlm_tags_LDADD =				\
	@GEE_LIBS@				\
	id3tag-x/libid3tag-x.la			\
	libmlm/libmlm.la			\
	$(NULL)

# ====== UI files

data_desktopdir = $(datadir)/applications
data_desktop_DATA = data/mlm.desktop

data_iconsdir = $(datadir)/icons/hicolor/scalable/apps
data_icons_DATA = data/mlm.svg

noinst_DATA =					\
	vapi/config.vapi			\
	vapi/id3tag.vapi			\
	vapi/mlm.vapi				\
	$(gresource_file)			\
	$(resource_files)			\
	$(NULL)

EXTRA_DIST =					\
	$(noinst_DATA)				\
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
