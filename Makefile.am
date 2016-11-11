AUTOMAKE_OPTIONS = subdir-objects

# ===== global

AM_CPPFLAGS =							\
	-include config.h					\
	-DLOCALEDIR=\""$(localedir)"\"				\
	-DPKGDATADIR=\""$(pkgdatadir)"\"			\
	-DPKGLIBDIR=\""$(pkglibdir)"\"

COMMON_VALAFLAGS =						\
	--enable-experimental					\
	--target-glib=2.38					\
	--vapidir $(top_srcdir)/vapi

# ====== libid3tag-x

noinst_LTLIBRARIES = lib/libid3tag-x.la

lib_libid3tag_x_la_SOURCES =					\
	lib/id3tag-x/id3tag-x.c					\
	lib/id3tag-x/id3tag-x.h

lib_libid3tag_x_la_CFLAGS = -Wall

# ====== libmlm

noinst_LTLIBRARIES += lib/libmlm.la

lib_libmlm_la_SOURCES =						\
	lib/mlm/genres.vala					\
	lib/mlm/file-tags.vala					\
	lib/mlm/pretty-box.vala					\
	lib/mlm/util.vala

lib_libmlm_la_VALAFLAGS =					\
	$(COMMON_VALAFLAGS)					\
	--vapi vapi/mlm.vapi					\
	--header lib/mlm/mlm.h					\
	@GEE_PACKAGES@						\
	@GIO_PACKAGES@						\
	@ID3TAG_PACKAGES@

lib_libmlm_la_CFLAGS =						\
	@GEE_CFLAGS@						\
	@GIO_CFLAGS@						\
	@ID3TAG_CFLAGS@						\
	-I$(srcdir)/lib/id3tag-x				\
	-w

lib_libmlm_la_LIBADD =						\
	@GEE_LIBS@						\
	@GIO_LIBS@						\
	@ID3TAG_LIBS@						\
	lib/libid3tag-x.la

# ====== mlm

bin_PROGRAMS = src/mlm

src_mlm_SOURCES =						\
	src/gui/application-window.vala				\
	src/gui/application.vala				\
	src/gui/encoder.vala					\
	src/gui/main.vala					\
	src/gui/media.vala					\
	src/gui/player.vala					\
	src/gui/resources.c					\
	vapi/mlm.vapi

src_mlm_VALAFLAGS =						\
	$(COMMON_VALAFLAGS)					\
	@GEE_PACKAGES@						\
	@GSTREAMER_PACKAGES@					\
	@GTK_PACKAGES@						\
	--pkg posix						\
	--pkg config						\
	--gresources $(gresource_file)

src_mlm_CFLAGS =						\
	@GEE_CFLAGS@						\
	@GSTREAMER_CFLAGS@					\
	@GTK_CFLAGS@						\
	-I$(srcdir)/lib/mlm					\
	-w

src_mlm_LDADD =							\
	@GEE_LIBS@						\
	@GSTREAMER_LIBS@					\
	@GTK_LIBS@						\
	lib/libmlm.la

# ====== mlm-tags

bin_PROGRAMS += src/mlm-tags

src_mlm_tags_SOURCES =						\
	src/tags/tags.vala					\
	vapi/mlm.vapi

src_mlm_tags_VALAFLAGS =					\
	$(COMMON_VALAFLAGS)					\
	@GEE_PACKAGES@

src_mlm_tags_CFLAGS =						\
	@GEE_CFLAGS@						\
	-I$(srcdir)/lib/id3tag-x				\
	-I$(srcdir)/lib/mlm					\
	-w

src_mlm_tags_LDADD =						\
	@GEE_LIBS@						\
	lib/libid3tag-x.la					\
	lib/libmlm.la

# ====== mlm-accommodator

bin_PROGRAMS += src/mlm-accommodator

src_mlm_accommodator_SOURCES =					\
	src/accommodator/accommodator.vala			\
	vapi/mlm.vapi

src_mlm_accommodator_VALAFLAGS =				\
	$(COMMON_VALAFLAGS)					\
	@GEE_PACKAGES@						\
	@GIO_PACKAGES@

src_mlm_accommodator_CFLAGS =					\
	@GEE_CFLAGS@						\
	@GIO_CFLAGS@						\
	-I$(srcdir)/lib/id3tag-x				\
	-I$(srcdir)/lib/mlm					\
	-w

src_mlm_accommodator_LDADD =					\
	@GEE_LIBS@						\
	@GIO_LIBS@						\
	lib/libid3tag-x.la					\
	lib/libmlm.la

# ====== mlm-verify

bin_PROGRAMS += src/mlm-verify

src_mlm_verify_SOURCES =					\
	src/verify/verify.vala					\
	vapi/mlm.vapi

src_mlm_verify_VALAFLAGS =					\
	$(COMMON_VALAFLAGS)					\
	@ID3TAG_PACKAGES@					\
	@GEE_PACKAGES@						\
	@GIO_PACKAGES@						\
	@GDK_PIXBUF_PACKAGES@

src_mlm_verify_CFLAGS =						\
	@ID3TAG_CFLAGS@						\
	@GEE_CFLAGS@						\
	@GIO_CFLAGS@						\
	@GDK_PIXBUF_CFLAGS@					\
	-I$(srcdir)/lib/id3tag-x				\
	-I$(srcdir)/lib/mlm					\
	-w

src_mlm_verify_LDADD =						\
	@ID3TAG_LIBS@						\
	@GEE_LIBS@						\
	@GIO_LIBS@						\
	@GDK_PIXBUF_LIBS@					\
	lib/libid3tag-x.la					\
	lib/libmlm.la

# ====== mlm-copy-tags

bin_PROGRAMS += src/mlm-copy-tags

src_mlm_copy_tags_SOURCES =					\
	src/copy-tags/copy-tags.vala				\
	vapi/mlm.vapi

src_mlm_copy_tags_VALAFLAGS =					\
	$(COMMON_VALAFLAGS)					\
	@GLIB_PACKAGES@						\
	@GEE_PACKAGES@						\
	@ID3TAG_PACKAGES@

src_mlm_copy_tags_CFLAGS =					\
	@GLIB_CFLAGS@						\
	@GEE_CFLAGS@						\
	@ID3TAG_CFLAGS@						\
	-I$(srcdir)/lib/id3tag-x				\
	-I$(srcdir)/lib/mlm					\
	-w

src_mlm_copy_tags_LDADD =					\
	@GLIB_LIBS@						\
	@GEE_LIBS@						\
	@ID3TAG_LIBS@						\
	lib/libid3tag-x.la					\
	lib/libmlm.la

# ====== mlm-analyze

bin_PROGRAMS += src/mlm-analyze

src_mlm_analyze_SOURCES =					\
	src/analyze/analyze.vala				\
	vapi/mlm.vapi

src_mlm_analyze_VALAFLAGS =					\
	$(COMMON_VALAFLAGS)					\
	@ID3TAG_PACKAGES@

src_mlm_analyze_CFLAGS =					\
	@GLIB_CFLAGS@						\
	@ID3TAG_CFLAGS@						\
	-I$(srcdir)/lib/id3tag-x				\
	-I$(srcdir)/lib/mlm					\
	-w

src_mlm_analyze_LDADD =						\
	@GLIB_LIBS@						\
	@ID3TAG_LIBS@						\
	lib/libid3tag-x.la					\
	lib/libmlm.la

# ====== gresource

gresource_file = $(top_srcdir)/data/mlm.gresource.xml
resource_files = 						\
	$(top_srcdir)/data/mlm.css				\
	$(top_srcdir)/data/mlm.ui

src/gui/resources.c: $(gresource_file) $(resource_files)
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) 			\
		--target=$@					\
		--sourcedir=$(top_srcdir)/data			\
		--generate-source $<

# ====== Desktop files

data_desktopdir = $(datadir)/applications
data_desktop_DATA = data/mlm.desktop

data_iconsdir = $(datadir)/icons/hicolor/scalable/apps
data_icons_DATA = data/mlm.svg

noinst_DATA =							\
	vapi/config.vapi					\
	vapi/id3tag.vapi					\
	vapi/mlm.vapi						\
	$(gresource_file)					\
	$(resource_files)

EXTRA_DIST =							\
	$(noinst_DATA)						\
	$(data_desktop_DATA)					\
	$(data_icons_DATA)

DISTCLEANFILES =						\
	src/mlm.h						\
	vapi/mlm.vapi

SUBDIRS = po

# ====== man pages

if ENABLE_MANPAGES
man1_MANS =							\
	man/mlm-tags.1

XML_FILES = $(patsubst %.1,%.xml,$(man1_MANS))
HTML_FILES = $(patsubst %.1,%.html,$(man1_MANS))

.PHONY: man
man: $(man1_MANS) $(HTML_FILES)

AM_V_XSLT = $(AM_V_XSLT_$(V))
AM_V_XSLT_ = $(AM_V_XSLT_$(AM_DEFAULT_VERBOSITY))
AM_V_XSLT_0 = @echo "  XSLT    " $@;

XSLTPROC_FLAGS =						\
	--nonet							\
	--xinclude						\
	--stringparam man.output.quietly 1			\
	--stringparam man.authors.section.enabled 0		\
	--stringparam man.copyright.section.enabled 0		\
	--stringparam mlm.version $(VERSION)			\
	--path '$(builddir)/man:$(srcdir)/man'

man/%.1: man/%.xml man/custom-man.xsl
	$(AM_V_XSLT)$(XSLTPROC) -o $@ $(XSLTPROC_FLAGS)		\
		$(srcdir)/man/custom-man.xsl $<


man/%.html: man/%.xml man/custom-html.xsl
	$(AM_V_XSLT)$(XSLTPROC) -o $@ $(XSLTPROC_FLAGS)		\
		$(srcdir)/man/custom-html.xsl $<

EXTRA_DIST +=							\
	$(man1_MANS)

CLEANFILES =							\
	$(man1_MANS)						\
	$(HTML_FILES)

noinst_DATA += $(HTML_FILES)
endif
