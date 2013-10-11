AC_INIT([mlm],
        [0.1],
        [https://github.com/canek-pelaez/mlm/issues],
        [mlm],
        [https://github.com/canek-pelaez/mlm])
AC_CONFIG_SRCDIR([src/mlm-tags.vala])

AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_AUX_DIR([build-aux])

AM_INIT_AUTOMAKE([1.11 no-dist-gzip dist-xz])
LT_INIT

AC_PROG_CC
AM_PROG_CC_C_O
AC_PROG_CC_STDC
AM_PROG_VALAC([0.20])
AC_PROG_INSTALL

GTK_PACKAGES="--pkg gtk+-3.0 --pkg gstreamer-1.0"
PKG_CHECK_MODULES(GTK, [ gtk+-3.0 gstreamer-1.0 ])

AC_SUBST(GTK_CFLAGS)
AC_SUBST(GTK_LIBS)
AC_SUBST(GTK_PACKAGES)

MLM_PACKAGES="--pkg gee-1.0 --pkg id3tag "
PKG_CHECK_MODULES(MLM, [ gee-0.8 id3tag ])

AC_SUBST(MLM_CFLAGS)
AC_SUBST(MLM_LIBS)
AC_SUBST(MLM_PACKAGES)

IT_PROG_INTLTOOL([0.40])

GETTEXT_PACKAGE=AC_PACKAGE_NAME
AC_SUBST(GETTEXT_PACKAGE)
AC_DEFINE_UNQUOTED(GETTEXT_PACKAGE,"$GETTEXT_PACKAGE",[The name of the gettext domain])

AC_CONFIG_FILES([
	Makefile
        po/Makefile.in
])

AC_OUTPUT
