customman = join_paths(meson.current_source_dir(), 'custom-man.xsl')
customhtml = join_paths(meson.current_source_dir(), 'custom-html.xsl')

man1dir = join_paths(get_option('mandir'), 'man1')

commonargs = [
  xsltproc,
  '--nonet',
  '--xinclude',
  '--stringparam', 'man.output.quietly', '1',
  '--stringparam', 'man.authors.section.enabled', '1',
  '--stringparam',  'man.copyright.section.enabled', '1',
  '--stringparam', 'mlm.version', meson.project_version(),
  '--path', meson.current_source_dir(),
  '-o', '@OUTPUT@'
]

genman1 = [ commonargs, customman, '@INPUT@' ]

name = 'analyze'
custom_target('mlm-' + name + '.1',
              output: 'mlm-' + name + '.1',
              input: 'mlm-' + name + '.xml',
              command: genman1, install: true, install_dir: man1dir)
name = 'copy-tags'
custom_target('mlm-' + name + '.1',
              output: 'mlm-' + name + '.1',
              input: 'mlm-' + name + '.xml',
              command: genman1, install: true, install_dir: man1dir)
name = 'tags'
custom_target('mlm-' + name + '.1',
              output: 'mlm-' + name + '.1',
              input: 'mlm-' + name + '.xml',
              command: genman1, install: true, install_dir: man1dir)
