if exists("g:sandwich#recipes")
let b:sandwich_magicchar_f_patterns = [
                              \   {
                              \     'header' : '\<\%(\h\k*\.\)*\h\k*',
                              \     'bra'    : '(',
                              \     'ket'    : ')',
                              \     'footer' : '',
                              \   },
                              \ ]

let g:sandwich#recipes += [
  \    {'buns': ['"""', '"""']}
  \  ]
endif  " sandwich directory


nmap <buffer> K :YcmCompleter GetDoc<cr>
nmap <buffer> <c-]> :YcmCompleter GoTo<cr>
nmap <buffer> <c-t> :YcmCompleter GetType<cr>
