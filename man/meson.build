if xsltproc.found() and get_option('enable-doc')
  customman = files('custom-man.xsl')
  customhtml = files('custom-html.xsl')

  flags = [
    '--nonet',
    '--xinclude',
    '--stringparam', 'man.output.quietly', '1',
    '--stringparam', 'man.authors.section.enabled', '1',
    '--stringparam',  'man.copyright.section.enabled', '1',
    '--stringparam', 'mlm.version', '@0@'.format(meson.project_version()),
    '--path', '@0@:@1@'.format(meson.current_build_dir(),
                               meson.current_source_dir())
  ]

  command = [ xsltproc, '-o', '@OUTPUT@' ] + flags

  manpages = [ 'analyze', 'copy-tags', 'tags' ]
  man_pages = []
  html_pages = []

  foreach manpage : manpages
    stem = 'mlm-' + manpage
    xml = stem + '.xml'
    html = stem + '.html'
    man = stem + '.1'
    mandir = join_paths(get_option('mandir'), 'man1')
    htmldir = join_paths(docdir, 'html')

    p1 = custom_target(man,
                       input : xml,
                       output : man,
                       command : command + [ customman, '@INPUT@' ],
                       install : true,
                       install_dir : mandir )
    man_pages += [ p1 ]

    p2 = custom_target(html,
                       input : xml,
                       output : html,
                       command : command + [ customhtml, '@INPUT@' ],
                       install : true,
                       install_dir : htmldir )
    html_pages += [ p2 ]

  endforeach

  man = custom_target('man',
                      output: 'man',
                      depends: man_pages,
                      command: ['echo'])

  html = custom_target('html',
                      output: 'html',
                      depends: html_pages,
                      command: ['echo'])
endif
