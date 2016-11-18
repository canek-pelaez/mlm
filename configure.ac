# Initialization
AC_INIT([mlm], [0.1], [https://github.com/canek-pelaez/mlm/issues],
        [mlm], [https://github.com/canek-pelaez/mlm])
AC_CONFIG_SRCDIR([src/application/main.vala])

# Directories and files
AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_HEADERS([config.h])

# Global options
AM_INIT_AUTOMAKE([1.11 foreign no-dist-gzip dist-xz])
AM_SILENT_RULES([yes])
LT_INIT

# Compilers and utilities
AC_PROG_CC
AM_PROG_CC_C_O
AC_PROG_CC_STDC
AM_PROG_VALAC([0.32])
AC_PROG_INSTALL

# Glib resources
AC_PATH_PROG([GLIB_COMPILE_RESOURCES], [glib-compile-resources])

# xsltproc
AC_PATH_PROG([XSLTPROC], [xsltproc])

# Man pages
have_manpages=no
AC_ARG_ENABLE(manpages,
              AS_HELP_STRING([--disable-manpages],
                             [disable manpages]))
AS_IF([test "${enable_manpages}" != no],
      [have_manpages=yes])
AM_CONDITIONAL(ENABLE_MANPAGES,
               [test "${have_manpages}" = "yes" -a "${XSLTPROC}" != ""])

# glib
GLIB_PACKAGES=["--pkg glib-2.0"]
PKG_CHECK_MODULES(GLIB, [ glib-2.0 ])
AC_SUBST(GLIB_CFLAGS)
AC_SUBST(GLIB_LIBS)
AC_SUBST(GLIB_PACKAGES)

# gio
GIO_PACKAGES=["--pkg gio-2.0"]
PKG_CHECK_MODULES(GIO, [ gio-2.0 ])
AC_SUBST(GIO_CFLAGS)
AC_SUBST(GIO_LIBS)
AC_SUBST(GIO_PACKAGES)

# gee
GEE_PACKAGES=["--pkg gee-0.8"]
PKG_CHECK_MODULES(GEE, [ gee-0.8 ])
AC_SUBST(GEE_CFLAGS)
AC_SUBST(GEE_LIBS)
AC_SUBST(GEE_PACKAGES)

# id3tag
ID3TAG_PACKAGES=["--pkg id3tag"]
PKG_CHECK_MODULES(ID3TAG, [ id3tag ])
AC_SUBST(ID3TAG_CFLAGS)
AC_SUBST(ID3TAG_LIBS)
AC_SUBST(ID3TAG_PACKAGES)

# gtk+
GTK_PACKAGES=["--pkg gtk+-3.0"]
PKG_CHECK_MODULES(GTK, [ gtk+-3.0 ])
AC_SUBST(GTK_CFLAGS)
AC_SUBST(GTK_LIBS)
AC_SUBST(GTK_PACKAGES)

# gdk-pixbuf
GDK_PIXBUF_PACKAGES=["--pkg gdk-pixbuf-2.0"]
PKG_CHECK_MODULES(GDK_PIXBUF, [ gdk-pixbuf-2.0 ])
AC_SUBST(GDK_PIXBUF_CFLAGS)
AC_SUBST(GDK_PIXBUF_LIBS)
AC_SUBST(GDK_PIXBUF_PACKAGES)

# gstreamer
GSTREAMER_PACKAGES=["--pkg gstreamer-1.0"]
PKG_CHECK_MODULES(GSTREAMER, [ gstreamer-1.0 ])
AC_SUBST(GSTREAMER_CFLAGS)
AC_SUBST(GSTREAMER_LIBS)
AC_SUBST(GSTREAMER_PACKAGES)

# gettext
AM_GNU_GETTEXT([external])
AM_GNU_GETTEXT_VERSION([0.19.7])
GETTEXT_PACKAGE=AC_PACKAGE_NAME
AC_SUBST(GETTEXT_PACKAGE)
AC_DEFINE_UNQUOTED(GETTEXT_PACKAGE, "${GETTEXT_PACKAGE}",
                   [The name of the gettext domain])

# Output files
AC_CONFIG_FILES([
	Makefile
        po/Makefile.in
])
AC_OUTPUT
