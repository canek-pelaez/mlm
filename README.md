Music Library Maintainer
========================

MLM stands for Music Library Maintainer, and is a collection of small utilities
itended to, as its name implies, maintain a music library. It does so by reading
and writting a subset of Id3v2.4.0 tags, hencefort refered as the "standard
tags".

Standard tags
-------------

The standard tags are:

* Artist (`TPE1`)
* Title (`TIT2`)
* Album (`TALB`)
* Album band (`TPE2`), usually called "Album artist" in other suites
* Year (`TDRC`)
* Track (`TRCK`), including the total number of tracks on the disc
* Disc number (`TPOS`)
* Genre (`TCON`), the standard 148 genres from Id3v1
* Comment (`COMM`)
* Composer (`TCOM`)
* Original artist (`TOPE`)
* Album and artist picture (`APIC`)

Utilities
─────────

The utilities are:

* `mlm-gui`: A GNOME 3 program to edit standard tags, and perhaps playing or
  reencoding the file containing them.

* `mlm-accommodator`: Command line tool to acommodate an MP3 file in a standard
  hierarchical location.

* `mlm-analyze`: Command line tool to analyze all the Id3v2.4.0 tags (not only the
  standard ones) in an MP3 file.

* `mlm-copy-tags`: Command line tool to copy the standard tags from an MP3 file to
  another.

* `mlm-tags`: Command line tool to modify or print the standard tags of a file or
  group of files.

* `mlm-verify`: Command line tool to verify that an MP3 file follows the MLM
  standard.

All the command line utilities accept a `--help` argument that explains how to
use it, and include man pages.
