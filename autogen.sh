#!/bin/sh

set -e # exit on errors

srcdir=$(dirname $0)
test -z "${srcdir}" && srcdir=.

mkdir -p m4

autoreconf -v --force --install

if [ -z "${NOCONFIGURE}" ]; then
    "${srcdir}"/configure $@
fi
