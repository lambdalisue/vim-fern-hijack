if exists('g:loaded_fern_hijack') || ( !has('nvim') && v:version < 801 )
  finish
endif
let g:loaded_fern_hijack = 1

function! s:hijack_directory() abort
  let path = s:expand('%:p')
  if !isdirectory(path)
    return
  endif
  let bufnr = bufnr()
  execute printf('keepjumps keepalt Fern %s', fnameescape(path))
  execute printf('silent! bwipeout %d', bufnr)
endfunction

function! s:suppress_netrw() abort
  if exists('#FileExplorer')
    autocmd! FileExplorer *
  endif
endfunction

" Called every BufEnter, but checks if fern#util#expand exists, thus preventing unnecessary load of fern.vim.
function! s:expand(expr) abort
  if exists('fern#util#expand')
    return fern#util#expand(a:expr)
  endif
  return expand(a:expr)
endfunction

augroup fern-hijack
  autocmd!
  autocmd VimEnter * call s:suppress_netrw()
  autocmd BufEnter * ++nested call s:hijack_directory()
augroup END
