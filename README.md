# vim-scroll-position

This plugin displays the relative position of the cursor within the buffer
on the left side of the screen using the `sign` feature.

![vim-scroll-position](https://github.com/junegunn/vim-scroll-position/raw/master/screenshot1.png)

- `>` Current position
- `-` Latest jump position
- `x` Latest change position

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
" let g:scroll_position_change = 'x'

set t_Co=256

hi SignColumn                  ctermbg=232
hi ScrollPositionMarker        ctermfg=208 ctermbg=232
hi ScrollPositionVisualBegin   ctermfg=196 ctermbg=232
hi ScrollPositionVisualMiddle  ctermfg=196 ctermbg=232
hi ScrollPositionVisualEnd     ctermfg=196 ctermbg=232
hi ScrollPositionVisualOverlap ctermfg=196 ctermbg=232
hi ScrollPositionChange        ctermfg=124 ctermbg=232
hi ScrollPositionJump          ctermfg=131 ctermbg=232
```

### Display of visual range

You can configure how to display visual range on the gutter using `g:scroll_position_visual` variable.

#### `let g:scroll_position_visual = 1`

![vim-scroll-position](https://github.com/junegunn/vim-scroll-position/raw/master/screenshot2.png)

#### `let g:scroll_position_visual = 2`

This looks better, but considerably slower than mode 1.

![vim-scroll-position](https://github.com/junegunn/vim-scroll-position/raw/master/screenshot3.png)
