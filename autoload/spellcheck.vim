""""""""""""""""""""""""""""""" Include guard """""""""""""""""""""""""""""" {{{
if exists('g:loaded_sweedlerNotesSpellcheck')
  finish
endif
let g:loaded_sweedlerNotesSpellcheck = 1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
"""""""""""""""""""""""""""""""""" Start """"""""""""""""""""""""""""""""" {{{
let s:spellchecking = 0
function! spellcheck#start()
  let save_cursor = getcurpos()
  let s:spellchecking = 1

  " If we start on a misspelled word, we need to take a step back to operate
  " on it when we call 'forward'
  normal ge

  " The main spellcheck loop {{{
  while s:spellchecking
    call spellcheck#forward()
    call spellcheck#menu()
  endwhile " }}}

  call setpos('.', save_cursor)
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
"""""""""""""""""""""""" next - dispatch callback """""""""""""""""""""""" {{{
function! spellcheck#menu()
  " Highlight the word we're operating on (mark it, then highlight to end of
  " word)
  normal mz
  let @/ = "\\w*\\%'z\\w*"
  set hlsearch

  " Update the screen before asking the user for input
  redraw

  " Get user input
  let msg = "What do you wanna do?"
  let choice = confirm(msg, s:GetChoicesString())

  " 'confirm' indexes from 1,,, as opposed to arrays which index from 0
  let l:Func = s:choices[choice-1][1]

  " Dispatch callback
  call l:Func()

  " Make a new entry in the undo sequence
  call lib#break_undo()
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
"""""""""""""""""""""""""" spellcheck callbacks """""""""""""""""""""""""" {{{
function! spellcheck#surround_backticks()
  normal viws`
endfunction

function! spellcheck#surround_underline()
  normal viws_
endfunction

function! spellcheck#zEqual()
  normal 1z=
endfunction

function! spellcheck#zg()
  normal zg
endfunction

function! spellcheck#back()
  normal [s
endfunction

function! spellcheck#forward()
  normal ]s
endfunction

function! spellcheck#end()
  let s:spellchecking = 0
  nohlsearch
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
""""""""""""""""""""""""""""" define the menu """""""""""""""""""""""""""" {{{
" TODO instead of `autocorrect` what if I could display the top N spellings
" I can use 'complete_info(["spell"])' & slice it.
let s:choices = []
let s:choices += [["&` code literal", function("spellcheck#surround_backticks")]]
let s:choices += [["&_ ignore", function("spellcheck#surround_underline")]]
let s:choices += [["&z= autocorrect", function("spellcheck#zEqual")]]
let s:choices += [["&learn word", function("spellcheck#zg")]]
let s:choices += [["&back", function("spellcheck#back")]]
let s:choices += [["&forward", function("spellcheck#forward")]]
let s:choices += [["&quit spellshecker", function("spellcheck#end")]]
function! s:GetChoicesString()
  return mapnew(s:choices, 'v:val[0]')->join("\n")
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
