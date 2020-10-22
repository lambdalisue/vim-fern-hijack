if exists('g:loaded_fern_hijack') || ( !has('nvim') && v:version < 801 )
  finish
endif
let g:loaded_fern_hijack = 1

function! s:hijack_directory() abort
  let path = s:expand('%:p')
  if !isdirectory(path)
    return
  endif
  bwipeout %
  execute printf('keepjumps keepalt Fern %s', fnameescape(path))
endfunction

function! s:suppress_netrw() abort
  if exists('#FileExplorer')
    autocmd! FileExplorer *
  endif
endfunction

function! s:expand(expr) abort
  try
    return fern#util#expand(a:expr)
  catch /^Vim\%((\a\+)\)\=:E117:/
    return expand(a:expr)
  endtry
endfunction

augroup fern-hijack
  autocmd!
  autocmd VimEnter * call s:suppress_netrw()
  autocmd BufEnter * ++nested call s:hijack_directory()
augroup END
