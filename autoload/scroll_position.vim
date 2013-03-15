if exists("g:scroll_position_loaded") || !has('signs')
  finish
endif
let g:scroll_position_loaded = 1

function scroll_position#show()
  let s:types = {}

  if exists("g:scroll_position_jump")
    exec "sign define scroll_position_j text=".g:scroll_position_jump." texthl=ScrollPositionJump"
    let s:types['j'] = "''"
  endif
  if exists("g:scroll_position_change")
    exec "sign define scroll_position_c text=".g:scroll_position_change." texthl=ScrollPositionchange"
    let s:types['c'] = "'."
  endif

  " For visual range
  let s:vtypes = copy(s:types)
  if !exists("g:scroll_position_visual_begin")
    let g:scroll_position_visual_begin = '^'
  endif
  if !exists("g:scroll_position_visual_middle")
    let g:scroll_position_visual_middle = ':'
  endif
  if !exists("g:scroll_position_visual_end")
    let g:scroll_position_visual_end = 'v'
  endif
  if !exists("g:scroll_position_visual_overlap")
    let g:scroll_position_visual_overlap = '<>'
  endif

  if !exists("g:scroll_position_marker")
    let g:scroll_position_marker = '>'
  endif
  let s:types['m'] = "."
  exec "sign define scroll_position_m text=".g:scroll_position_marker." texthl=ScrollPositionMarker"

  let s:vtypes['vb'] = "."
  let s:vtypes['ve'] = "v"
  exec "sign define scroll_position_vb text=".g:scroll_position_visual_begin." texthl=ScrollPositionVisualBegin"
  exec "sign define scroll_position_vm text=".g:scroll_position_visual_middle." texthl=ScrollPositionVisualMiddle"
  exec "sign define scroll_position_ve text=".g:scroll_position_visual_end." texthl=ScrollPositionVisualEnd"
  exec "sign define scroll_position_vo text=".g:scroll_position_visual_overlap." texthl=ScrollPositionVisualOverlap"

  if !exists("g:scroll_position_exclusion")
    let g:scroll_position_exclusion = "&buftype == 'nofile'"
  endif

  augroup ScrollPosition
    autocmd!
    autocmd WinEnter,CursorMoved,CursorMovedI,VimResized * :call scroll_position#update()
  augroup END

  let s:format = "sign place 99999%d line=%d name=scroll_position_%s buffer=%d"
  let s:scroll_position_enabled = 1
  call scroll_position#update()
endfunction

function! s:NumSort(a, b)
  return a:a>a:b ? 1 : a:a==a:b ? 0 : -1
endfunction

function scroll_position#update()
  if eval(g:scroll_position_exclusion)
    return
  endif

  let top    = line('w0')
  let lines  = line('$')
  let height = line('w$') - top + 1
  let bfr    = bufnr('%')

  if !exists('b:scroll_position_pplaces')
    let b:scroll_position_pplaces = {}
    let b:scroll_position_plines = line('$')
  endif
  if mode() == 'v'
    let types = s:vtypes
  else
    let types = s:types
  endif

  let places = {}
  let places_r = {}
  let pplaces = b:scroll_position_pplaces
  for [type, l] in items(types)
    let line = line(l)
    if line
      let lineno = top + float2nr(height * (line - 1) / lines)
      if type == 'vb' || type == 've'
        let places_r[ type ] = lineno
      else
        let places[ lineno ] = type
      endif
    endif
  endfor

  " Remove all previous signs when total number of lines changed
  let pkeys = keys(pplaces)
  if lines != b:scroll_position_plines
    let temp_lineno = top + float2nr(height * (line('.') - 1) / lines)
    exec printf("sign place 888880 line=%d name=scroll_position_m buffer=%d", temp_lineno, bfr)
    for pos in pkeys
      exec printf("sign unplace 99999%d buffer=%d", pos, bfr)
    endfor
  endif

  " Place signs when required
  " - Total number of lines changed (cleared)
  " - New position
  " - Type changed
  for [pos, type] in items(places)
    if lines != b:scroll_position_plines || !has_key(pplaces, pos) || type != pplaces[pos]
      exec printf(s:format, pos, pos, type, bfr)
    endif
  endfor

  " Display visual range
  if mode() == 'v'
    let [b, e] = sort([places_r['vb'], places_r['ve']], 's:NumSort')
    if b < e
      let places[b] = 'vb'
      let places[e] = 've'

      exec printf(s:format, b, b, 'vb', bfr)
      for l in range(b + 1, e - 1)
        exec printf(s:format, l, l, 'vm', bfr)
        let places[l] = 'vm'
      endfor
      exec printf(s:format, e, e, 've', bfr)
    else
      let places[b] = 'vo'
      exec printf(s:format, b, b, 'vo', bfr)
    endif
  endif

  " Remove invalidated signs (after placing new signs!)
  let keys = keys(places)
  if lines == b:scroll_position_plines
    for pp in pkeys
      if index(keys, pp) == -1
        exec printf("sign unplace 99999%d buffer=%d", pp, bfr)
      endif
    endfor
  else
    exec printf("sign unplace 888880 buffer=%d", bfr)
  endif

  let b:scroll_position_plines = lines
  let b:scroll_position_pplaces = places
endfunction

function scroll_position#hide()
  augroup ScrollPosition
    autocmd!
  augroup END
 " FIXME
  sign unplace *
  let b:scroll_position_pplaces = {}
  let b:scroll_position_plines = 0
  let s:scroll_position_enabled = 0
endfunction

function scroll_position#toggle()
  if s:scroll_position_enabled
    call scroll_position#hide()
  else
    call scroll_position#show()
  endif
endfunction
