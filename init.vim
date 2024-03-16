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

" set spell check to English and enable it
:setlocal spell spelllang=en_us


" Disable annoying auto brackets thing
let g:AutoPairs = {}

" disable popup transparency
highlight Pmenu ctermbg=Grey
highlight PmenuSel ctermbg=Grey
highlight Normal ctermbg=Grey
highlight NonText ctermbg=Grey
" I added everything below for LaTeX
syntax enable
let maplocalleader = ","
" The following should make latex highlighting possible
" within none .tex source files
let g:tex_flavor = "latex"

