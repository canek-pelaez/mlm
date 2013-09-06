AC_INIT([music-collection],
        [0.1],
        [https://github.com/canek-pelaez/music-collection/issues],
        [music-collection],
        [https://github.com/canek-pelaez/music-collection])
AC_CONFIG_SRCDIR([src/music-collection-fix-pictures.vala])

AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_AUX_DIR([build-aux])

AM_INIT_AUTOMAKE([1.11 no-dist-gzip dist-xz])

AC_PROG_CC
AM_PROG_CC_C_O
AC_PROG_CC_STDC
AM_PROG_VALAC([0.20])
AC_PROG_INSTALL
AC_PROG_RANLIB

MUSICCOLLECTION_PACKAGES="--pkg id3tag"
PKG_CHECK_MODULES(MUSICCOLLECTION, [ gobject-2.0 id3tag ])

AC_SUBST(MUSICCOLLECTION_CFLAGS)
AC_SUBST(MUSICCOLLECTION_LIBS)
AC_SUBST(MUSICCOLLECTION_PACKAGES)

#IT_PROG_INTLTOOL([0.40])

#GETTEXT_PACKAGE=AC_PACKAGE_NAME
#AC_SUBST(GETTEXT_PACKAGE)
#AC_DEFINE_UNQUOTED(GETTEXT_PACKAGE,"$GETTEXT_PACKAGE",[The name of the gettext domain])

AC_CONFIG_FILES([
	Makefile
])
#        po/Makefile.in

AC_OUTPUT
