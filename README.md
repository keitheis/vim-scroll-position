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
set t_Co=256

highlight ScrollPositionMarker ctermfg=208 ctermbg=232
highlight ScrollPositionChange ctermfg=124 ctermbg=232
highlight ScrollPositionJump ctermfg=131 ctermbg=232
highlight SignColumn ctermbg=232

" Default markers
" let g:scroll_position_marker = '>'
" let g:scroll_position_jump = '-'
" let g:scroll_position_change = '+'
```
