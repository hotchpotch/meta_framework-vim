
"ruby << EOF
"  load '/home/gorou/git/github/meta_framework-vim/lib/meta_framework.rb'
"  #p VIM::Method.expand('#1:P')
"EOF

function! s:sub(str,pat,rep)
  return substitute(a:str,'\v\C'.a:pat,a:rep,'')
endfunction

map <SID>xx <SID>xx
let g:MetaFrameworkSID = s:sub(maparg("<SID>xx"),'xx$','')
unmap <SID>xx

let s:meta_framework_file = fnamemodify(resolve(expand('<sfile>:p')), ':p:h') . '/lib/meta_framework.rb'
execute 'rubyfile ' . s:meta_framework_file

autocmd BufEnter * ruby MetaFramework.registry_buffer
"augroup metaFramework
"  autocmd!
"  autocmd User BufEnterMetaFramework call echo 'hello'
"  autocmd User BufEnterMetaFramework ruby MetaFramework.registry_buffer
"  autocmd BufEnter * doau User
"  
"  " autocmd User BufEnterMetaFramework call s:RefreshBuffer()
"augroup END
