if exists('g:loaded_fern_hijack') || ( !has('nvim') && v:version < 801 )
  finish
endif
let g:loaded_fern_hijack = 1

function! s:hijack_directory(path) abort
  if !isdirectory(a:path)
    return
  endif
  let bufnr = bufnr()
  execute printf('keepjumps keepalt Fern %s', fnameescape(a:path))
  execute printf('silent! bwipeout %d', bufnr)
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

function! s:initial_hijack() abort
	call s:hijack_directory(expand('%:p'))
	autocmd fern-hijack BufEnter * ++nested call s:hijack_directory(s:expand('%:p'))
endfunction

augroup fern-hijack
  autocmd!
  autocmd VimEnter * call s:suppress_netrw()
  autocmd BufEnter * ++once ++nested call s:initial_hijack()
augroup END
