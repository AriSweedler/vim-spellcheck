" This should be an optional plugin.
" TODO Can I get away with using <buffer> local mappings? I'll need to invoke
" this for every buffer where I want it. Do I allowlist the filetypes?
nnoremap <buffer> <Leader>z :call spellcheck#start()<CR>
nnoremap <buffer> <Leader>Z [s:call spellcheck#start()<CR>
