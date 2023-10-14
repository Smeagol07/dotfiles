local k = vim.keymap
local conf = require('telescope.config').values
local builtin = require('telescope.builtin')

local last_query = ''

local ripgrep = function(opt)
  local query = opt.args
  local vimgrep_arguments = conf.vimgrep_arguments
  if query == '' then
    query = last_query
  else
    last_query = query
  end
  local dirs = { vim.fn.getcwd() }

  if query:match('%s[%w%p]*%/$') then
    local dir = query:gsub('(.-) ([^%s]*%/)$', '%2')
    if dir:byte(1) ~= 47 then -- /
      dir = query:gsub('(.-) ([^%s]+%/)$', '%2')
    end
    dirs = { dir }
    query = query:gsub('(.-) ([^%s]+%/)$', '%1')
  elseif query:match('%s%%$') then
    dirs = { vim.fn.expand('%') }
    query = query:gsub('(.-) %%$', '%1')
  end

  if query:match([[^!(.*)$]]) then
    query = query:gsub([[^!(.*)$]], '%1')
    opt.regex = true
  end

  local options = ''
  if query:match('^%-s ') then
    query = query:sub(4)
    vimgrep_arguments[#vimgrep_arguments + 1] = '-s'
    options = '[-s] '
  end
  if query:match('^%-i ') then
    query = query:sub(4)
    vimgrep_arguments[#vimgrep_arguments + 1] = '-i'
    options = '[-i] '
  end

  local message = ''
  if opt.regex then
    message = options .. 'r/' .. query .. '/'
  else
    message = options .. '"' .. query .. '"'
  end

  local short_dirs = {}
  for _, dir in pairs(dirs) do
    if dir ~= vim.fn.getcwd() then
      short_dirs[#short_dirs + 1] = dir:gsub('^.*%.%/', '')
    end
  end
  if #short_dirs > 0 then
    message = message .. ' in ' .. table.concat(short_dirs, ', ')
  end
  print(message)
  builtin.grep_string({
    search = query,
    use_regex = opt.regex,
    search_dirs = dirs,
    vimgrep_arguments = vimgrep_arguments,
  })
end

function _G.ripgrep_in_dir_complete(text)
  local result = {}

  local dirs = vim.fn.globpath('.', '**/')

  local lead = text:gsub('.*%s', '')
  local query = text:sub(1, text:len() - lead:len())

  for name, _ in dirs:gmatch('.-\n') do
    name, _ = name:gsub('^%.%/(.-)\n$', '%1')
    if name:sub(1, lead:len()) == lead then
      table.insert(result, query .. name)
    end
  end

  table.sort(result, function(val1, val2)
    if val1:gsub('[^%/]', ''):len() ~= val2:gsub('[^%/]', ''):len() then
      return val1:gsub('[^%/]', ''):len() < val2:gsub('[^%/]', ''):len()
    else
      return val1 < val2
    end
  end)

  return result
end

k.set('n', '<plug>(ripgrep-search)', function()
  vim.ui.input({
    prompt = 'Rg: ',
    default = '',
    completion = 'customlist,v:lua.ripgrep_in_dir_complete',
  }, function(query)
    if query then
      ripgrep({ args = query, regex = false })
    end
  end)
end)

-- grep with regexp
k.set('n', '<plug>(ripgrep-with-regex)', function()
  local query = vim.fn.input({
    prompt = 'Rg!: ',
    default = '',
    cancelreturn = 0,
  })
  if type(query) == 'string' then
    ripgrep({ args = query, regex = true })
  end
end)

vim.cmd([[
  nmap <silent> <plug>(ripgrep-op) :set opfunc=Ripgrep_from_motion<cr>g@
  function! Ripgrep_from_motion(type, ...)
    let l:tmp = @a
    if a:0  " Invoked from Visual mode, use '< and '> marks.
      silent exe("normal! `<" . a:type . "`>\"ay")
    elseif a:type == 'line'
      silent exe "normal! '[V']\"ay"
    elseif a:type == 'block'
      silent exe "normal! `[\<C-V>`]\"ay"
    else
      silent exe "normal! `[v`]\"ay"
    endif
    call v:lua.require('ripgrep').ripgrep({"args": trim(@a)})
    " exe("Rg " . trim(@a))
    let @a = l:tmp
  endfunction
]])

return { ripgrep = ripgrep }
