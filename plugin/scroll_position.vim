if exists("g:scroll_position")
  finish
endif
let g:scroll_position = 1

if !exists('g:scroll_position_enabled')
  let g:scroll_position_enabled = 1
endif

call scroll_position#show()

command! -nargs=0 ScrollPositionShow call scroll_position#show()
command! -nargs=0 ScrollPositionHide call scroll_position#hide()
command! -nargs=0 ScrollPositionToggle call scroll_position#toggle()
