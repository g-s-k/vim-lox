if exists('b:did_indent')
  finish
endif
let b:did_indent = 1

setlocal nolisp smartindent
setlocal indentkeys+=0],0)

let b:undo_indent = 'setlocal smartindent< indentkeys<'
