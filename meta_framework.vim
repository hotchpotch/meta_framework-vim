
function! s:InvokeCommandComplete(A,L,P)
  execute "ruby MetaFramework.invoke_command_complete " . shellescape(a:A) . ", " . shellescape(a:L) .  ", " . shellescape(a:P)
  return g:MetaFrameworkRES
endfunction

function! s:InvokeCommand(bang, cmd, ...)
  let option = ''
  if len(a:000)
    let option .= ', ' . join(map(copy(a:000), 'shellescape(v:val)'), ', ')
  endif

  execute "ruby MetaFramework.invoke_command " . shellescape(a:bang) . ", " . shellescape(a:cmd) . option
  return g:MetaFrameworkRES
endfunction

let s:meta_framework_file = fnamemodify(resolve(expand('<sfile>:p')), ':p:h') . '/lib/meta_framework.rb'
execute 'rubyfile ' . s:meta_framework_file

map <SID>xx <SID>xx
execute "ruby MetaFramework.sid = " . shellescape(substitute(maparg("<SID>xx"),'xx$','', ''))
unmap <SID>xx


autocmd BufEnter * ruby MetaFramework.registry_buffer
"augroup metaFramework
"  autocmd!
"  autocmd User BufEnterMetaFramework call echo 'hello'
"  autocmd User BufEnterMetaFramework ruby MetaFramework.registry_buffer
"  autocmd BufEnter * doau User
"  
"  " autocmd User BufEnterMetaFramework call s:RefreshBuffer()
"augroup END
