let g:switch_custom_definitions =
      \ [
      \   {
      \     '\(===\)': '==',
      \     '\(==\)':  '===',
      \   },
      \   {
      \     '\(!==\)': '!=',
      \     '\(!=\)':  '!==',
      \   },
      \   {
      \     'show': 'hide',
      \     'hide':  'show',
      \   },
      \ ]
let s:switch_c_like_if =
      \ {
      \   'if (true || (\(.*\)))':          'if (false && (\1))',
      \   'if (false && (\(.*\)))':         'if (\1)',
      \   'if (\%(true\|false\)\@!\(.*\))': 'if (true || (\1))',
      \ }
let s:switch_c_like_while =
      \ {
      \   'while (true || (\(.*\)))':          'while (false && (\1))',
      \   'while (false && (\(.*\)))':         'while (\1)',
      \   'while (\%(true\|false\)\@!\(.*\))': 'while (true || (\1))',
      \ }
let s:switch_php_scope =
      \ {
      \   '\<private\>':   'protected',
      \   '\<protected\>': 'public',
      \   '\<public\>':    'private',
      \ }
let s:switch_php_array =
      \ {
      \   '\<array(\(.*\))':      '[\1]',
      \   '\(\s*\|^\)\[\(.*\)\]': '\1array(\2)',
      \ }
let s:switch_php_comment =
      \ {
      \   '^\(\s*\)/\* \(.*\) \*/$':      '\1// \2',
      \   '^\(\s*\)// \(.*\)': '\1/* \2 */',
      \ }
let s:switch_php_magento_dispatch_event =
      \ {
      \   'Mage::dispatchEvent': '$this->_eventManager->dispatch',
      \   '$this->_eventManager->dispatch': 'Mage::dispatchEvent',
      \ }

let s:switch_elixir_assert =
      \ {
      \   '\(assert\)': 'refute',
      \   '\(refute\)': 'assert',
      \ }
let s:switch_elixir_map =
      \ {
      \   '\<\([a-zA-Z0-9_]*\): \([^,]*\),':   '"\1" => \2,',
      \   '"\([a-zA-Z0-9_]*\)" => \([^,]*\),': '\1: \2,',
      \ }
let s:switch_blade_echo =
      \ {
      \   '{{\(.\{-}\)}}':   '{!!\1!!}',
      \   '{!!\(.\{-}\)!!}':   '{{\1}}',
      \ }
let s:switch_md_checkbox =
      \ {
      \   '\[ \]':   '[x]',
      \   '\[x\]':   '[ ]',
      \ }
let s:switch_vimwiki_checkbox =
      \ {
      \   '\[ \]':   '[o]',
      \   '\[\.\]':   '[o]',
      \   '\[o\]':   '[X]',
      \   '\[O\]':   '[X]',
      \   '\[X\]':   '[ ]',
      \ }
let s:switch_quotes =
      \ {
      \   '"\([^"]*\)"': "'\\1'",
      \   "'\\([^']*\\)'": '"\1"',
      \ }

augroup swich_vim
  autocmd!
  autocmd FileType blade let b:switch_custom_definitions =
        \ [
        \   s:switch_blade_echo,
        \   s:switch_quotes,
        \ ]
  autocmd FileType php let b:switch_custom_definitions =
        \ [
        \   s:switch_c_like_if,
        \   s:switch_c_like_while,
        \   s:switch_php_array,
        \   s:switch_php_comment,
        \   s:switch_php_scope,
        \   s:switch_php_magento_dispatch_event,
        \   s:switch_quotes,
        \ ]
  autocmd FileType javascript let b:switch_custom_definitions =
        \ [
        \   s:switch_c_like_if,
        \   s:switch_quotes,
        \ ]
  autocmd FileType javascript.jsx let b:switch_custom_definitions =
        \ [
        \   s:switch_c_like_if,
        \   s:switch_quotes,
        \ ]
  autocmd FileType elixir let b:switch_custom_definitions =
        \ [
        \   s:switch_elixir_assert,
        \   s:switch_elixir_map,
        \   s:switch_quotes,
        \ ]
  autocmd FileType markdown,md let b:switch_custom_definitions =
        \ [
        \   s:switch_md_checkbox,
        \   s:switch_quotes,
        \ ]
  autocmd FileType vimwiki let b:switch_custom_definitions =
        \ [
        \   s:switch_vimwiki_checkbox,
        \   s:switch_quotes,
        \ ]
  autocmd FileType email let b:switch_custom_definitions =
        \ [
        \   s:switch_quotes,
        \ ]
augroup END