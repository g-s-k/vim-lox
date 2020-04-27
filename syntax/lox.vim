" Vim syntax file
" Language:     Lox

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'lox'
endif

syntax sync fromstart
syntax case match

syntax match   loxNoise           /[,;]/
syntax match   loxDot             /\./ skipwhite skipempty nextgroup=loxField,loxFuncCall
syntax match   loxField           contained /\<\K\k*/
syntax match   loxFuncCall        /\<\K\k*\ze\s*(/
syntax match   loxParensError     /[)}\]]/

" Keywords
syntax keyword loxVar             var skipwhite skipempty nextgroup=loxVariableDef
syntax match   loxVariableDef     contained /\<\K\k*/ skipwhite skipempty
syntax keyword loxOperatorKeyword and or skipwhite skipempty nextgroup=@loxExpression
syntax match   loxOperator        "[-!+<>=/*]" skipwhite skipempty nextgroup=@loxExpression
syntax keyword loxBuiltins        clock
syntax keyword loxPrint           print
syntax keyword loxReturn          return contained
syntax keyword loxThis            this contained
syntax keyword loxSuper           super contained
syntax keyword loxInit            init contained

" Literals
syntax keyword loxNil             null
syntax keyword loxBooleanTrue     true
syntax keyword loxBooleanFalse    false
syntax region  loxString          start=+\z(["]\)+  skip=+\\\%(\z1\|$\)+  end=+\z1+ end=+$+ extend
syntax match   loxNumber          /\c\<\%(\d\+\%(e[+-]\=\d\+\)\=\|0b[01]\+\|0o\o\+\|0x\x\+\)\>/
syntax match   loxFloat           /\c\<\%(\d\+\.\d\+\|\d\+\.\|\.\d\+\)\%(e[+-]\=\d\+\)\=\>/

" Statement Keywords
syntax keyword loxConditional     if skipwhite skipempty nextgroup=loxParenIfElse
syntax keyword loxConditional     else skipwhite skipempty nextgroup=loxParenIfElse
syntax keyword loxRepeat          while for skipwhite skipempty nextgroup=loxParenRepeat

" Code blocks
syntax region  loxBracket         matchgroup=loxBrackets start=/\[/ end=/\]/ contains=@loxExpression extend fold
syntax region  loxParen           matchgroup=loxParens start=/(/ end=/)/ contains=@loxExpression extend fold
syntax region  loxParenIfElse     contained matchgroup=loxParensIfElse start=/(/ end=/)/  contains=@loxAll skipwhite skipempty nextgroup=loxCommentIfElse,loxIfElseBlock,loxReturn extend fold
syntax region  loxParenRepeat      contained matchgroup=loxParensRepeat start=/(/ end=/)/ contains=@loxAll skipwhite skipempty nextgroup=loxCommentRepeat,loxRepeatBlock,loxReturn extend fold
syntax region  loxFuncArgs         contained matchgroup=loxFuncParens start=/(/ end=/)/ contains=loxFuncArgCommas,loxComment,loxFuncArgExpression skipwhite skipempty nextgroup=loxCommentFunction,loxFuncBlock extend fold
syntax region  loxClassBlock       contained matchgroup=loxClassBraces start=/{/ end=/}/  contains=loxClassFuncName,loxComment,loxNoise extend fold
syntax region  loxFuncBlock        contained matchgroup=loxFuncBraces start=/{/ end=/}/ contains=@loxAll,loxBlock extend fold
syntax region  loxIfElseBlock      contained matchgroup=loxIfElseBraces start=/{/ end=/}/ contains=@loxAll,loxBlock extend fold
syntax region  loxRepeatBlock      contained matchgroup=loxRepeatBraces start=/{/ end=/}/  contains=@loxAll,loxBlock extend fold
syntax region  loxBlock            matchgroup=loxBraces start=/{/ end=/}/ contains=@loxAll extend fold

" Functions
syntax match   loxFuncName         contained /\<\K\k*/ skipwhite skipempty nextgroup=loxFuncArgs
syntax match   loxFuncArgCommas    contained ','

syntax match loxFunction /\<fun\>/ skipwhite skipempty nextgroup=loxFuncName skipwhite

" Classes
syntax keyword loxClassKeyword     contained class
syntax keyword loxInheritOperator  contained < skipwhite skipempty nextgroup=@loxExpression
syntax match   loxClassNoise       contained /\./
syntax match   loxClassFuncName    contained /\<\K\k*\ze\s*[(<]/ skipwhite skipempty nextgroup=loxFuncArgs
syntax region  loxClassDefinition  start=/\<class\>/ end=/\(\<<\>\)\@<!{\@=/ contains=loxClassKeyword,loxInheritOperator,loxClassNoise,@loxExpression skipwhite skipempty nextgroup=loxCommentClass,loxClassBlock

" Comments
syntax keyword loxCommentTodo      contained TODO FIXME XXX TBD NOTE
syntax region  loxComment          start=+//+ end=/$/ contains=loxCommentTodo,@Spell extend keepend
syntax region  loxEnvComment       start=/\%^#!/ end=/$/ display

" Specialized Comments - These are special comment regexes that are used in
" odd places that maintain the proper nextgroup functionality. It sucks we
" can't make loxComment a skippable type of group for nextgroup
syntax region  loxCommentFunction  contained start=+//+ end=/$/ contains=loxCommentTodo,@Spell skipwhite skipempty nextgroup=loxFuncBlock extend keepend
syntax region  loxCommentClass     contained start=+//+ end=/$/ contains=loxCommentTodo,@Spell skipwhite skipempty nextgroup=loxClassBlock extend keepend
syntax region  loxCommentIfElse    contained start=+//+ end=/$/ contains=loxCommentTodo,@Spell skipwhite skipempty nextgroup=loxIfElseBlock extend keepend
syntax region  loxCommentRepeat    contained start=+//+ end=/$/ contains=loxCommentTodo,@Spell skipwhite skipempty nextgroup=loxRepeatBlock extend keepend

syntax cluster loxExpression       contains=loxBracket,loxParen,loxString,loxNumber,loxFloat,loxOperator,loxOperatorKeyword,loxBooleanTrue,loxBooleanFalse,loxNil,loxFunction,loxPrint,loxBuiltins,loxFuncCall,loxNoise,loxClassDefinition,loxComment,loxThis,loxSuper,loxDot
syntax cluster loxAll              contains=@loxExpression,loxConditional,loxRepeat,loxReturn,loxNoise

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_lox_syn_inits")
  if version < 508
    let did_lox_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink loxComment              Comment
  HiLink loxEnvComment           PreProc
  HiLink loxParensIfElse         loxParens
  HiLink loxParensRepeat         loxParens
  HiLink loxCommentTodo          Todo
  HiLink loxString               String
  HiLink loxConditional          Conditional
  HiLink loxVar                  Statement
  HiLink loxReturn               Statement
  HiLink loxRepeat               Repeat
  HiLink loxFunction             Type
  HiLink loxFuncName             Function
  HiLink loxFuncCall             Function
  HiLink loxClassFuncName        loxFuncName
  HiLink loxArguments            Special
  HiLink loxParensError          Error
  HiLink loxPrint                Statement
  HiLink loxOperatorKeyword      loxOperator
  HiLink loxOperator             Operator
  HiLink loxClassKeyword         Structure
  HiLink loxInheritOperator      Operator
  HiLink loxThis                 Identifier
  HiLink loxSuper                Identifier
  HiLink loxNil                  Special
  HiLink loxNumber               Number
  HiLink loxFloat                Float
  HiLink loxBooleanTrue          Boolean
  HiLink loxBooleanFalse         Boolean
  HiLink loxNoise                Noise
  HiLink loxDot                  Noise
  HiLink loxBrackets             Noise
  HiLink loxParens               Noise
  HiLink loxBraces               Noise
  HiLink loxFuncBraces           Noise
  HiLink loxFuncParens           Noise
  HiLink loxClassBraces          Noise
  HiLink loxClassNoise           Noise
  HiLink loxIfElseBraces         Noise
  HiLink loxRepeatBraces         Noise
  HiLink loxBuiltins             Constant
  HiLink loxClassDefinition      loxFuncName

  HiLink loxCommentFunction      loxComment
  HiLink loxCommentClass         loxComment
  HiLink loxCommentIfElse        loxComment
  HiLink loxCommentRepeat        loxComment

  delcommand HiLink
endif


let b:current_syntax = "lox"
if main_syntax == 'lox'
  unlet main_syntax
endif
