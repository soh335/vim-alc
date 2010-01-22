let s:save_cpo = &cpo
set cpo&vim

"global vars
let s:open_cmd = 'w3m'

"global functions
function! alc#search(str)

  call alc#open(a:str)

  let s:history_index += 1
  call add(s:history, a:str)
  if len(s:history) > g:alc_history_num
    call remove(s:history, 0)
  endif

endfunction

function! alc#open(str)

  if !executable(s:open_cmd)
    return
  endif

  let bufnr = 0
  for i in range(1, winnr('$'))
    let n = winbufnr(i)
    if getbufvar(n, '&filetype') == 'alc'
      execute i 'wincmd w'
      let bufnr = i
      break
    endif
  endfor

  if bufnr == 0
    silent execute g:alc_open
    enew
    call s:initialize_buffer()
  else
    setlocal modifiable
    setlocal noreadonly
    % delete _
  endif

  call s:open(a:str)
endfunction

function! alc#jump(...)
  if a:0 && a:1 == 'v'
    let reg = @@
    normal! gvy
    let query = @@
    let @@ = reg
  else
    let query = expand('<cword>')
  endif

  call alc#search(query)
endfunction

function! alc#get_history_list()
  echo s:history
endfunction

"local functions
function! s:get_history(type)

  if a:type == 'back'
    if s:history_index > 0
      let s:history_index -= 1
      call alc#open(get(s:history, s:history_index))
    else
      call s:error("can't back")
    endif
  elseif a:type == 'foward'
    if s:history_index < g:alc_history_num && s:history_index < len(s:history) - 1
      let s:history_index += 1
      call alc#open(get(s:history, s:history_index))
    else
      call s:error("can't foward")
    endif
  end

endfunction

function! s:initialize_buffer()
  setlocal nonumber
  setlocal noswapfile
  setlocal buftype=nofile
  setlocal bufhidden=delete
  setlocal noshowcmd
  setlocal nowrap
  setlocal filetype=alc

  let s:history = []
  let s:history_index = -1

  nnoremap <buffer> <Plug>(alc-foward) :<C-u>call <SID>get_history('foward')<CR>
  nnoremap <buffer> <Plug>(alc-back) :<C-u>call <SID>get_history('back')<CR>

endfunction

function! s:error(str)
  echohl ErrorMsg 
  echo a:str
  echohl None
endfunction

function! s:open(str)
  let l:body = system(s:open_cmd.' "http://eow.alc.co.jp/'.a:str.'/UTF-8/?ref=sa"')
  execute 'silent 1 put = l:body'
  execute "normal! ".g:alc_start_linenumber."z\<CR>"

  setlocal readonly
  setlocal nomodifiable
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
