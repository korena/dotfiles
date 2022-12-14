let g:config_files = [
      \ 'globals.vim',
      \ 'options.vim',
      \ 'autocommands.vim',
      \ 'plugins.vim',
      \ 'mappings.vim',
      \ 'themes.vim',
      \ ]

for s:fname in g:config_files
  execute printf('source %s/core/%s', stdpath('config'), s:fname)
endfor

" Set spellcheck to English and enable it
:setlocal spell spelllang=en_us

