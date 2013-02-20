if exists("g:scroll_position_loaded") || !has('signs')
  finish
endif
let g:scroll_position_loaded = 1

function scroll_position#show()
  let s:types = {}
  let s:types_order = []

  if exists("g:scroll_position_jump")
    exec "sign define scroll_position_jump text=".g:scroll_position_jump." texthl=ScrollPositionJump"
    let s:types['jump'] = "''"
    call add(s:types_order, 'jump')
  endif
  if exists("g:scroll_position_change")
    exec "sign define scroll_position_change text=".g:scroll_position_change." texthl=ScrollPositionchange"
    let s:types['change'] = "'."
    call add(s:types_order, 'change')
  endif

  if !exists("g:scroll_position_marker")
    let g:scroll_position_marker = '>'
  endif
  let s:types['marker'] = "."
  call add(s:types_order, 'marker')
  exec "sign define scroll_position_marker text=".g:scroll_position_marker." texthl=ScrollPositionMarker"

  if !exists("g:scroll_position_exclusion")
    let g:scroll_position_exclusion = "&buftype == 'nofile'"
  endif

  augroup ScrollPosition
    autocmd!
    autocmd WinEnter,CursorMoved,CursorMovedI,VimResized * :call scroll_position#update()
  augroup END

  let s:scroll_position_enabled = 1
  call scroll_position#update()
endfunction

function scroll_position#update()
  if exists('g:scroll_position_exclusion') && eval(g:scroll_position_exclusion)
    return
  endif

  let top    = line('w0')
  let lines  = line('$')
  let height = line('w$') - top + 1
  let bfr    = bufnr('%')

  if !exists('b:scroll_position_prev')
    let b:scroll_position_prev = {}
  endif

  let places = {}
  let pplaces = b:scroll_position_prev
  for [type, l] in items(s:types)
    let line = line(l)
    if line
      let places[ top + float2nr(height * (line - 1) / lines) ] = type
    endif
  endfor

  for [pos, type] in items(places)
    if !has_key(pplaces, pos) || type != pplaces[pos]
      exec printf("sign place 99999%s line=%s name=scroll_position_%s buffer=%s", pos, pos, type, bfr)
    endif
  endfor

  for pp in keys(pplaces)
    if index(keys(places), pp) == -1
      exec printf("sign unplace 99999%s buffer=%s", pp, bfr)
    endif
  endfor

  let b:scroll_position_prev = places
endfunction

function scroll_position#hide()
  augroup ScrollPosition
    autocmd!
  augroup END
  sign unplace *
  let b:scroll_position_prev = {}
  let s:scroll_position_enabled = 0
endfunction

function scroll_position#toggle()
  if s:scroll_position_enabled
    call scroll_position#hide()
  else
    call scroll_position#show()
  endif
endfunction
