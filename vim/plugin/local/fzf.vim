" prepare params
function! s:params(params, preview)
  let preview = get(g:,'fzf_preview', '')
  let params = join(a:params, ' ')
  if (len(params) && params[0] != '-')
    let params = '-q ' . shellescape(params)
  endif
  if !empty(a:preview)
    return preview . ' ' . params
  else
    return params
  endif
endfunction

" fzf git ls
function! s:fzf_git_ls_sink(line)
  let result = substitute(a:line, '^...', '', '')
  execute('e ' . result)
endfunction

function! local#fzf#all_files(...) abort
  let options = {
        \   'options': '--prompt "All files> " ' . s:params(a:000, 1),
        \ }
  let extra = extend(copy(get(g:, 'fzf_layout', {'down': '~40%'})), options)
  call fzf#run(fzf#wrap('name', extra, 0))
endfunction

function! local#fzf#files(...) abort
  let options = {
        \   'source': 'ag -l -g ""',
        \   'options': '--prompt "Files> " ' . s:params(a:000, 1),
        \ }
  let extra = extend(copy(get(g:, 'fzf_layout', {'down': '~40%'})), options)
  call fzf#run(fzf#wrap('name', extra, 0))
endfunction


function! local#fzf#buffer_dir_files(...) abort
  let options = {
        \   'source': 'ag -l -g "" ' . shellescape(expand('%:h')),
        \   'options': '--prompt "Files> " ' . s:params(a:000, 1),
        \ }
  let extra = extend(copy(get(g:, 'fzf_layout', {'down': '~40%'})), options)
  call fzf#run(fzf#wrap('name', extra, 0))
endfunction

function! local#fzf#git_ls(...) abort
  let options = {
        \   'source': 'git-ls',
        \   'sink': function('s:fzf_git_ls_sink'),
        \   'options': '--ansi --prompt "Git> " ' . s:params(a:000, 1),
        \ }
  let extra = extend(copy(get(g:, 'fzf_layout', {'down': '~40%'})), options)
  call fzf#run(fzf#wrap('name', extra, 0))
endfunction

" Better Ag search (with optional dir specified)
function! s:fzf_ag_process(string, escape) abort
  if a:escape
    return shellescape(a:string)
  else
    return a:string
  endif
endfunction

function! s:fzf_ag_params(raw, params) abort
  if empty(a:params)
    return get(s:, 'last_ag_params', '')
  endif

  let l:dir = a:params[-1]
  if l:dir=~ '/$' && isdirectory(dir)
    let l:params = a:params[0:-2]
    let l:suffix = ' ' . l:dir
  else
    let l:params = a:params
    let l:suffix = ''
  endif

  let l:flags = []
  let l:query = []

  let l:query_started = v:false
  for l:param in l:params
    if !l:query_started && l:param[0] == '-'
      call add(l:flags, l:param)
    else
      let l:query_started = v:true
      call add(l:query, l:param)
    endif
  endfor

  let l:query = join(l:query, ' ')
  let l:flags = join(l:flags, ' ')

  if (!a:raw)
    let l:quote = l:query[0] =~ "[^\"']"
  else
    let l:quote = !a:raw
  endif

  echom l:query[0] =~ "[\"']"
  let l:query = s:fzf_ag_process(l:query, l:quote)

  let s:last_ag_params = l:flags . ' ' . l:query . l:suffix
  return s:last_ag_params
endfunction

function! local#fzf#ag(raw, ...) abort
  let params = s:fzf_ag_params(a:raw, a:000)
  echo "!ag " . params
  call fzf#vim#ag_raw(params)
endfunction

function! local#fzf#rg(raw, ...) abort
  let params = s:fzf_ag_params(a:raw, a:000)
  echo "!rg -i " . params
  " call fzf#vim#ag_raw(params)
  call fzf#vim#grep(
        \   'rg --column --line-number --no-heading --color=always -i '.params, 1)
endfunction

function! local#fzf#agg(raw, ...) abort
  let params = s:fzf_ag_params(a:raw, a:000)
  silent! execute ":silent! grep " . params
  echo ":grep " . params
endfunction

function! s:fzf_clip_sink(line)
  echo system('anamnesis.sh to_clip', a:line)
endfunction

function! s:fzf_project_sink(line)
  if !empty(a:line)
    let path = $HOME . "/Projects/" . a:line
    silent! exec('Prosession ' . l:path)
    exec('cd ' . l:path)
    echo 'Prosession ' . getcwd()
  endif
endfunction

function! local#fzf#clip(...) abort
  let options = {
        \   'source': 'anamnesis.sh list',
        \   'sink': function('s:fzf_clip_sink'),
        \   'options': '--ansi --prompt "Clip> " ' . s:params(a:000, 0),
        \ }
  let extra = extend(copy(get(g:, 'fzf_layout', {'down': '~40%'})), options)
  call fzf#run(fzf#wrap('name', extra, 0))
endfunction

function! local#fzf#project(...) abort
  let options = {
        \   'source': 'ls-project',
        \   'sink': function('s:fzf_project_sink'),
        \   'options': '--ansi --prompt "Project> " ' . s:params(a:000, 0),
        \ }
  let extra = extend(copy(get(g:, 'fzf_layout', {'down': '~40%'})), options)
  call fzf#run(fzf#wrap('name', extra, 0))
endfunction

function! s:fzf_ft_sink(line)
  if !empty(a:line)
    let &ft=a:line
  endif
endfunction

function! local#fzf#ft(...) abort
  let options = {
        \   'source': [
        \       "css",
        \       "elixir",
        \       "go",
        \       "html",
        \       "javascript",
        \       "javascript.jsx",
        \       "php",
        \       "php.phtml",
        \       "ruby",
        \       "scss",
        \       "sh",
        \       "vim",
        \       "xml",
        \   ],
        \   'sink': function('s:fzf_ft_sink'),
        \   'options': '--print-query --ansi --prompt "FileType> " ' . s:params(a:000, 0),
        \ }
  let extra = extend(copy(get(g:, 'fzf_layout', {'down': '~40%'})), options)
  call fzf#run(fzf#wrap('name', extra, 0))
endfunction

function! local#fzf#vim_config(...) abort
  let options = {
        \   'source': 'ag -l -g "" ~/.config/nvim/init.vim ~/.vim/plugin/',
        \   'options': '--prompt "All files> " ' . s:params(a:000, 1),
        \ }
  let extra = extend(copy(get(g:, 'fzf_layout', {'down': '~40%'})), options)
  call fzf#run(fzf#wrap('name', extra, 0))
endfunction

function! local#fzf#mysnippets(...) abort
  let options = {
        \   'source': 'ag -l -g "" ~/.vim/mysnippets',
        \   'options': '--prompt "All files> " ' . s:params(a:000, 1),
        \ }
  let extra = extend(copy(get(g:, 'fzf_layout', {'down': '~40%'})), options)
  call fzf#run(fzf#wrap('name', extra, 0))
endfunction

function! local#fzf#mytemplates(...) abort
  let options = {
        \   'source': 'ag -l -g "" ~/.vim/mytemplates ~/.config/nvim/config/projectionist.vimrc',
        \   'options': '--prompt "All files> " ' . s:params(a:000, 1),
        \ }
  let extra = extend(copy(get(g:, 'fzf_layout', {'down': '~40%'})), options)
  call fzf#run(fzf#wrap('name', extra, 0))
endfunction

command! -nargs=* -bang -complete=dir FZFProject call local#fzf#project(<f-args>)

command! -nargs=* -bang -complete=dir Ag call local#fzf#ag(<bang>0,<f-args>)
command! -nargs=* -bang -complete=dir Agg call local#fzf#agg(<bang>0,<f-args>)
command! -nargs=* -bang -complete=dir Rg call local#fzf#rg(<bang>0,<f-args>)
command! -nargs=* -bang -complete=dir Rgg call local#fzf#agg(<bang>0,<f-args>)

command! -nargs=* -complete=dir FZFFileType call local#fzf#ft(<f-args>)
