customman = join_paths(meson.current_source_dir(), 'custom-man.xsl')
customhtml = join_paths(meson.current_source_dir(), 'custom-html.xsl')

xsltproc_flags = [
  '--nonet',
  '--xinclude',
  '--stringparam', 'man.output.quietly', '1',
  '--stringparam', 'man.authors.section.enabled', '0',
  '--stringparam',  'man.copyright.section.enabled', '0',
  '--stringparam', 'mlm.version', meson.project_version(),
  '--path', meson.current_source_dir()
]

input_files = [
  'mlm-tags.xml'
]

output_man_files = [
  'mlm-tags.1'
]

output_html_files = [
  'mlm-tags.html'
]

man_pages = custom_target('man-pages',
                          output: output_man_files,
                          input: input_files,
                          command: [ xsltproc,
                                     xsltproc_flags,
                                     '-o', '@OUTPUT@',
                                     customman, '@INPUT@'],
                          install: true,
                          install_dir: join_paths(get_option('mandir'), 'man1')
                         )

html_pages = custom_target('html-pages',
                           output: output_html_files,
                           input: input_files,
                           command: [ xsltproc,
                                      xsltproc_flags,
                                      '-o', '@OUTPUT@',
                                      customhtml, '@INPUT@'],
                           install: false,
                           install_dir: join_paths(get_option('mandir'), 'man1')
                          )
