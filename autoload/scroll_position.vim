if exists("g:scroll_position_loaded") || !has('signs')
  finish
endif
let g:scroll_position_loaded = 1

function scroll_position#show()
  if !exists("g:scroll_position_marker")
    let g:scroll_position_marker = '>'
  endif
  if !exists("g:scroll_position_exclusion")
    let g:scroll_position_exclusion = "&buftype == 'nofile'"
  endif

  exec "sign define scroll_position text=".g:scroll_position_marker." texthl=ScrollPositionMarker"

  augroup ScrollPosition
    autocmd!
    autocmd WinEnter,CursorMoved,CursorMovedI,VimResized * :call scroll_position#update()
  augroup END
endfunction

function scroll_position#update()
  if exists('g:scroll_position_exclusion') && eval(g:scroll_position_exclusion)
    return
  endif
  echo &buftype

  let lines  = line('$')
  let height = line('w$') - line('w0') + 1
  let pos    = line('w0') + float2nr( height * (line('.') - 1) / lines)
  if exists('b:scroll_position_prev')
    if b:scroll_position_prev != pos
      let b = bufnr('%')
      exec printf(":sign place %s line=%s name=scroll_position buffer=%s", pos, pos, b)
      exec printf(":sign unplace %s buffer=%s", b:scroll_position_prev, b)
    endif
  else
    exec printf(":sign place %s line=%s name=scroll_position buffer=%s", pos, pos, bufnr('%'))
  endif

  let b:scroll_position_prev = pos
endfunction

function scroll_position#hide()
  augroup ScrollPosition
    sign unplace *
    autocmd!
  augroup END
endfunction
