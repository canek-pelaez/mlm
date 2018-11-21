msgfmt = find_program('msgfmt')
podir = join_paths(meson.source_root(), 'po')

custom_target(
  'desktop-file',
  input: 'mlm.desktop.in',
  output: 'mlm.desktop',
  install: true,
  install_dir: join_paths(get_option('datadir'), 'applications'),
  command: [msgfmt, '--desktop', '--template', '@INPUT@',
            '-d', podir, '-o', '@OUTPUT@'],
)

icon_dir = join_paths(datadir, 'icons', 'hicolor', 'scalable', 'apps')
install_data(
  'mlm.svg',
  install_dir: icon_dir
)
