" Vim syntax file
" Language: Pro*C / Embedded SQL in C
" Purpose: C syntax + Pro*C keywords + embedded SQL highlighting

if exists('b:current_syntax')
  finish
endif

" Start from the normal C syntax.
runtime! syntax/c.vim
unlet! b:current_syntax

" Pull in Vim's SQL syntax into a syntax cluster that can be embedded in regions.
syntax include @ProcSQL syntax/sql.vim
unlet! b:current_syntax

" -----------------------------------------------------------------------------
" Pro*C specific keywords visible in C code as well
" -----------------------------------------------------------------------------
syntax keyword procKeyword EXEC SQL WHENEVER SQLCA ORACA VARCHAR VARYING
syntax keyword procSectionKeyword BEGIN END DECLARE SECTION INCLUDE CONTEXT
syntax keyword procConditionKeyword SQLERROR SQLWARNING NOTFOUND FOUND
syntax keyword procActionKeyword CONTINUE DO GOTO STOP BREAK nextgroup=procLabel skipwhite
syntax match   procLabel /\<[A-Za-z_][A-Za-z0-9_]*\>/ contained
syntax match   procHostVar /:\s*[A-Za-z_][A-Za-z0-9_]*/
syntax match   procIndicatorVar /:\s*[A-Za-z_][A-Za-z0-9_]*\s*:\s*[A-Za-z_][A-Za-z0-9_]*/
syntax match   procNotFound /\<NOT\>\_s\+\<FOUND\>/

" Common SQLCA / ORACA members that students often inspect.
syntax keyword procStructMember sqlca oraca sqlcode sqlerrm sqlerrd sqlwarn sqlstate

" Pro*C-only constructs that appear inside EXEC SQL statements and are not part
" of standard SQL syntax.
syntax keyword procSqlPseudoKeyword WHENEVER SQLERROR SQLWARNING FOUND NOTFOUND CONTINUE DO GOTO STOP BREAK DECLARE SECTION INCLUDE SQLCA ORACA contained
syntax match   procSqlNotFound /\<NOT\>\_s\+\<FOUND\>/ contained

" -----------------------------------------------------------------------------
" EXEC SQL ... ;
" -----------------------------------------------------------------------------
syntax region procExecSql matchgroup=procExecKeyword start=/\<EXEC\>\_s\+\<SQL\>\ze\_s/ end=/;/ keepend contains=@ProcSQL,procHostVar,procIndicatorVar,procSqlPseudoKeyword,procSqlNotFound

" Special handling for DECLARE SECTION so the delimiters stand out.
syntax region procDeclareSection matchgroup=procExecKeyword start=/\<EXEC\>\_s\+\<SQL\>\_s\+\<BEGIN\>\_s\+\<DECLARE\>\_s\+\<SECTION\>\_s*;/ end=/\<EXEC\>\_s\+\<SQL\>\_s\+\<END\>\_s\+\<DECLARE\>\_s\+\<SECTION\>\_s*;/ keepend contains=TOP,procHostVar,procIndicatorVar

" Special handling for WHENEVER so conditions and actions remain readable.
syntax region procWheneverStmt matchgroup=procExecKeyword start=/\<EXEC\>\_s\+\<SQL\>\_s\+\<WHENEVER\>\ze\_s/ end=/;/ keepend contains=procWhenKeyword,procCondition,procAction,procHostVar,procIndicatorVar,procSqlNotFound
syntax keyword procWhenKeyword WHENEVER contained
syntax keyword procCondition SQLERROR SQLWARNING FOUND NOTFOUND contained
syntax match   procCondition /\<NOT\>\_s\+\<FOUND\>/ contained
syntax keyword procAction CONTINUE DO GOTO STOP BREAK contained

" INCLUDE SQLCA / ORACA is so common that a dedicated match improves readability.
syntax match procIncludeStmt /\<EXEC\>\_s\+\<SQL\>\_s\+\<INCLUDE\>\_s\+\%(SQLCA\|ORACA\)\_s*;/

" -----------------------------------------------------------------------------
" Highlight links
" -----------------------------------------------------------------------------
highlight default link procKeyword           Keyword
highlight default link procSectionKeyword    PreProc
highlight default link procExecKeyword       PreProc
highlight default link procSqlPseudoKeyword  PreProc
highlight default link procSqlNotFound       Type
highlight default link procWhenKeyword       PreProc
highlight default link procCondition         Type
highlight default link procAction            Statement
highlight default link procHostVar           Identifier
highlight default link procIndicatorVar      Identifier
highlight default link procStructMember      Identifier
highlight default link procIncludeStmt       PreProc
highlight default link procLabel             Label
highlight default link procNotFound          Type

let b:current_syntax = 'proc'
