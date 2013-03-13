# vim-scroll-position

Displays relative cursor position on the left y-axis using signs feature.

![vim-scroll-position](https://github.com/junegunn/vim-scroll-position/raw/master/vim-scroll-position.png)

See the orange arrow on the left?
- `>` Current position
- `-` Latest jump position
- `+` Latest change position

## Installation

### With [Vundle](https://github.com/gmarik/vundle)

Add this line to your .vimrc
```
Bundle 'junegunn/vim-scroll-position'
```

Then,

```viml
:BundleInstall
```

### Help

```viml
:help vim-scroll-position
```

### Customization

```viml
" Default markers
let g:scroll_position_marker         = '>'
let g:scroll_position_visual_begin   = '^'
let g:scroll_position_visual_middle  = ':'
let g:scroll_position_visual_end     = 'v'
let g:scroll_position_visual_overlap = '<>'

" Additional markers disabled by default due to slow rendering
" let g:scroll_position_jump = '-'
" let g:scroll_position_change = '+'

set t_Co=256

hi SignColumn                  ctermbg=232
hi ScrollPositionMarker        ctermfg=208 ctermbg=232
hi ScrollPositionVisualBegin   ctermfg=208 ctermbg=232
hi ScrollPositionVisualMiddle  ctermfg=208 ctermbg=232
hi ScrollPositionVisualEnd     ctermfg=208 ctermbg=232
hi ScrollPositionVisualOverlap ctermfg=208 ctermbg=232
hi ScrollPositionChange        ctermfg=124 ctermbg=232
hi ScrollPositionJump          ctermfg=131 ctermbg=232
```
