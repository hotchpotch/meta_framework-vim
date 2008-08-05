
if exists('g:loaded_meta_framework') || v:version < 700 || !has("ruby")
  finish
endif
let g:loaded_meta_framework = 1

function! s:InvokeCommandComplete(A,L,P)
  execute "ruby MetaFramework.invoke_command_complete " . shellescape(a:A) . ", " . shellescape(a:L) .  ", " . shellescape(a:P)
  return g:MetaFrameworkRES
endfunction

function! s:InvokeCommand(...)
  " cmdname, command, bang, args
  let option = ''
  if len(a:000)
    let option .= join(map(copy(a:000), 'shellescape(v:val)'), ', ')
  endif

  execute "ruby MetaFramework.invoke_command " . option
  return g:MetaFrameworkRES
endfunction

let s:meta_framework_file = fnamemodify(resolve(expand('<sfile>:p')), ':p:h') . '/lib/meta_framework.rb'
execute 'rubyfile ' . s:meta_framework_file

map <SID>xx <SID>xx
execute "ruby MetaFramework.sid = " . shellescape(substitute(maparg("<SID>xx"),'xx$','', ''))
unmap <SID>xx

autocmd BufEnter * ruby MetaFramework.registry_current_buffer
