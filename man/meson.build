customman = join_paths(meson.current_source_dir(), 'custom-man.xsl')
customhtml = join_paths(meson.current_source_dir(), 'custom-html.xsl')

xsltproc_flags = [
  '--nonet',
  '--xinclude',
  '--stringparam', 'man.output.quietly', '1',
  '--stringparam', 'man.authors.section.enabled', '1',
  '--stringparam',  'man.copyright.section.enabled', '1',
  '--stringparam', 'mlm.version', meson.project_version(),
  '--path', meson.current_source_dir()
]

input_files = [
  'mlm-analyze.xml',
  'mlm-tags.xml'
]

output_man_files = [
  'mlm-analyze.1',
  'mlm-tags.1'
]

output_html_files = [
  'mlm-analyze.html',
  'mlm-tags.html'
]

mandir = join_paths(get_option('mandir'), 'man1')
htmldir = join_paths(get_option('datadir'), 'doc',
                     meson.project_name() + '-' + meson.project_version())

man_pages = custom_target('man-pages',
                          output: output_man_files,
                          input: input_files,
                          command: [ xsltproc,
                                     xsltproc_flags,
                                     '--output', 'man/',
                                     customman, '@INPUT@'],
                          install: true,
                          install_dir: mandir)

html_pages = custom_target('html-pages',
                           output: output_html_files,
                           input: input_files,
                           command: [ xsltproc,
                                      xsltproc_flags,
                                      '--output', 'man/',
                                      customhtml, '@INPUT@'],
                           install: false,
                           install_dir: htmldir)
