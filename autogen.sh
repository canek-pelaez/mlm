#!/bin/sh

set -e # exit on errors

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

mkdir -p m4
touch ChangeLog

autoreconf -v --force --install
intltoolize -f -c

if [ -z "$NOCONFIGURE" ]; then
    "$srcdir"/configure $@
fi
