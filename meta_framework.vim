
"ruby << EOF
"  load '/home/gorou/git/github/meta_framework-vim/lib/meta_framework.rb'
"  #p VIM::Method.expand('#1:P')
"EOF

"function! s:sub(str,pat,rep)
"  return substitute(a:str,'\v\C'.a:pat,a:rep,'')
"endfunction
"
"map <SID>xx <SID>xx
"let g:MetaFrameworkSID = s:sub(maparg("<SID>xx"),'xx$','')
"unmap <SID>xx

let s:meta_framework_file = expand('<sfile>:p:h') . '/lib/meta_framework.rb'
execute 'rubyfile ' . s:meta_framework_file

"augroup metaFramework
"  autocmd!
"  autocmd User BufEnterMetaFramework ruby MetaFramework::Buffer.new
"  autocmd BufEnter * silent doau User
"  
"  " autocmd User BufEnterMetaFramework call s:RefreshBuffer()
"augroup END
