fun! s:SelectLox()
  if getline(1) =~# '^#!.*/[cj]lox\>'
    set ft=lox
  endif
endfun

autocmd BufNewFile,BufRead *.lox setfiletype lox
autocmd BufNewFile,BufRead * call s:SelectLox()
