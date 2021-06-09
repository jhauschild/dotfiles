if isdirectory(expand('~/.config/nvim/plugged/vim-sandwich'))
let g:sandwich#recipes += [
  \    {'buns': ['```', '```']}
  \  ]
endif  " sandwich directory
