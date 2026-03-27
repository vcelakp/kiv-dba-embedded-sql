" Reuse the standard C ftplugin so indentation, comments and related options
" behave as students expect in Pro*C files.
runtime! ftplugin/c.vim ftplugin/c_*.vim ftplugin/c/*.vim

setlocal commentstring=/*%s*/
setlocal formatoptions+=croql
