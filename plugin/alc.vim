if exists('g:loaded_alc') || v:version < 702
  finish
endif
let g:loaded_alc = 1

let s:save_cpo = &cpo
set cpo&vim

function! s:set_default(key, value)
  if !exists(a:key)
    let {a:key} = a:value
  endif
endfunction

command! -nargs=+ Alc call alc#search(<q-args>)
nnoremap <silent> <Plug>(alc-keyword) :<C-u>call alc#jump()<CR>
vnoremap <silent> <Plug>(alc-keyword) :<C-u>call alc#jump('v')<CR>

call s:set_default('g:alc_start_linenumber', 33)
call s:set_default('g:alc_open', 'split')
call s:set_default('g:alc_history_num', 5)

let &cpo = s:save_cpo
unlet s:save_cpo
