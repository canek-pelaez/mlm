# General
project('mlm', ['vala', 'c'], version: '0.1')
add_global_arguments('-DGETTEXT_PACKAGE="mlm"', language: 'c')
vapidir = join_paths(meson.current_source_dir(), 'vapi')
add_project_arguments(['--enable-experimental',
                       '--vapidir=' + vapidir,
                       '--vapidir=.',
                       '--pkg=config',
                       '--target-glib=2.38'],
                      language: 'vala')

gdkpixbuf = dependency('gdk-pixbuf-2.0')
gee = dependency('gee-0.8')
gio = dependency('gio-2.0')
glib = dependency('glib-2.0')
gstreamer = dependency('gstreamer-1.0')
gtk = dependency('gtk+-3.0')
id3tag = dependency('id3tag')

xsltproc = find_program('xsltproc', required: false)

conf = configuration_data()
conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())
conf.set_quoted('LOCALEDIR', get_option('localedir'))
conf.set_quoted('LOCALSTATEDIR', get_option('localstatedir'))
conf.set_quoted('PACKAGE_VERSION', meson.project_version())
conf.set_quoted('VERSION', meson.project_version())

configure_file(output: 'config.h',
               configuration: conf)

prefixdir = get_option('prefix')
datadir = join_paths(prefixdir, get_option('datadir'))
docdir = join_paths(datadir, 'doc/mlm')

# libid3tagx
id3tagx_sources = [
  'lib/id3tag-x/id3tag-x.c',
  'lib/id3tag-x/id3tag-x.h'
]

id3tagx = static_library('id3tag-x', id3tagx_sources)

id3tagx_includes = include_directories('lib/id3tag-x')

# libmlm
mlm_sources = [
  'lib/mlm/genres.vala',
  'lib/mlm/file-tags.vala',
  'lib/mlm/pretty-box.vala',
  'lib/mlm/util.vala'
]

mlm_dependencies = [
  gee,
  gio,
  glib,
  id3tag
]

mlm = static_library('mlm', mlm_sources,
                     dependencies: mlm_dependencies,
                     include_directories: id3tagx_includes,
                     link_with: id3tagx)

mlm_includes = include_directories('lib/mlm')

# libtest (named check because of meson)
check_sources = [
  'lib/test/test-case.vala'
]

check = static_library('check', check_sources,
                       dependencies: [ glib ])

check_includes = include_directories('lib/test')

# tests
check_file_tags_vala_sources = [ 'test/test-file-tags.vala' ]
check_file_tags_sources = [
  check_file_tags_vala_sources,
  'test/test-file-tags-main.vala'
]

check_file_tags = executable('test-file-tags', check_file_tags_sources,
                        dependencies: [ gee, gio, gdkpixbuf ],
                        link_with: [ check, mlm ])
test('Test file-tags', check_file_tags, args: [ meson.source_root() ])

# command line utilities
executable('mlm-arrange', 'src/arrange/arrange.vala',
           dependencies: [ gee, gio ],
           include_directories: [ id3tagx_includes, mlm_includes ],
           link_with: [ id3tagx, mlm ],
           install: true)

executable('mlm-analyze', 'src/analyze/analyze.vala',
           dependencies: [ id3tag, gdkpixbuf, gee, gio ],
           include_directories: [ id3tagx_includes, mlm_includes ],
           link_with: [ id3tagx, mlm ],
           install: true)

executable('mlm-copy-tags', 'src/copy-tags/copy-tags.vala',
           dependencies: [ id3tag, gdkpixbuf, gee, gio ],
           include_directories: [ id3tagx_includes, mlm_includes ],
           link_with: [ id3tagx, mlm ],
           install: true)

executable('mlm-tags', 'src/tags/tags.vala',
           dependencies: [ gee ],
           include_directories: [ id3tagx_includes, mlm_includes ],
           link_with: [ id3tagx, mlm ],
           install: true)

executable('mlm-verify', 'src/verify/verify.vala',
           dependencies: [ id3tag, gdkpixbuf, gee, gio ],
           include_directories: [ id3tagx_includes, mlm_includes ],
           link_with: [ id3tagx, mlm ],
           install: true)

# resources
gnome = import('gnome')

gresources = gnome.compile_resources(
  'gresources', 'data/mlm.gresource.xml',
  source_dir: 'data',
  c_name: 'resources')

# main application
mlm_gui_sources = [
  'src/application/application-window.vala',
  'src/application/application.vala',
  'src/application/encoder.vala',
  'src/application/main.vala',
  'src/application/media.vala',
  'src/application/player.vala'
]

mlm_gui_dependencies = [
  gdkpixbuf,
  gee,
  gio,
  glib,
  gstreamer,
  gtk,
  id3tag
]

executable('mlm-gui', mlm_gui_sources + [ gresources ],
           dependencies: mlm_gui_dependencies,
           include_directories: [ id3tagx_includes, mlm_includes ],
           install: true, link_with: [ id3tagx, mlm ])

# man pages
subdir('man')

# static data
subdir('data')

# i10n
subdir('po')
