if exists("g:scroll_position_loaded") || !has('signs')
  finish
endif
let g:scroll_position_loaded = 1

function scroll_position#show()
  if !exists("g:scroll_position_marker")
    let g:scroll_position_marker = '>'
  endif
  if !exists("g:scroll_position_change")
    let g:scroll_position_change = '+'
  endif
  if !exists("g:scroll_position_jump")
    let g:scroll_position_jump = '-'
  endif
  if !exists("g:scroll_position_exclusion")
    let g:scroll_position_exclusion = "&buftype == 'nofile'"
  endif

  exec "sign define scroll_position_marker text=".g:scroll_position_marker." texthl=ScrollPositionMarker"
  exec "sign define scroll_position_change text=".g:scroll_position_change." texthl=ScrollPositionchange"
  exec "sign define scroll_position_jump text=".g:scroll_position_jump." texthl=ScrollPositionJump"

  let s:types = { 'jump': "''", 'change': "'.", 'marker': '.' }
  let s:types_order = ['jump', 'change', 'marker']

  augroup ScrollPosition
    autocmd!
    autocmd WinEnter,CursorMoved,CursorMovedI,VimResized * :call scroll_position#update()
  augroup END
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

  let unplaces = []
  for pp in keys(pplaces)
    if index(keys(places), pp) == -1
      call add(unplaces, pp)
    endif
  endfor

  for [pos, type] in items(places)
    if !has_key(pplaces, pos) || type != pplaces[pos]
      exec printf("sign place %s line=%s name=scroll_position_%s buffer=%s", pos, pos, type, bfr)
    endif
  endfor

  for up in unplaces
    exec printf("sign unplace %s buffer=%s", up, bfr)
  endfor

  let b:scroll_position_prev = places
endfunction

function scroll_position#hide()
  augroup ScrollPosition
    sign unplace *
    autocmd!
  augroup END
endfunction
