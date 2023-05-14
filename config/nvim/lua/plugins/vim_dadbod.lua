local k = vim.keymap
local g = vim.g
local b = vim.b
local fn = vim.fn
local cmd = vim.cmd
local l = {}

l.setup = function()
  -- behave different when changed to functions or <cmd>, so don't do it
  k.set('v', '<space>d', ':lua print("dadbod not loaded yet, select DB first")<cr>')
  k.set('v', '<space>D', ':lua print("dadbod not loaded yet, select DB first")<cr>')
  k.set('n', '<space>d', ':lua print("dadbod not loaded yet, select DB first")<cr>')
  k.set('n', '<space>D', ':lua print("dadbod not loaded yet, select DB first")<cr>')
end

l.config = function()
  -- behave different when changed to functions or <cmd>, so don't do it
  k.set('v', '<space>d', ':lua require"plugins.vim_dadbod".db_with_warning()<cr>')
  k.set('v', '<space>D', ':lua require"plugins.vim_dadbod".db_with_warning(true)<cr>')
  k.set('n', '<space>d', ':lua require"plugins.vim_dadbod".db_with_warning()<cr>')
  k.set('n', '<space>D', ':lua require"plugins.vim_dadbod".db_with_warning(true)<cr>')

  vim.api.nvim_create_autocmd('BufEnter', {
    group = vim.api.nvim_create_augroup('x_dadbod', { clear = true }),
    pattern = '*.dbout',
    callback = function()
      cmd.wincmd('L')
      -- alternate file override for dbout && sql file
      k.set('n', '<space>ta', function()
        local dbout = vim.fn.expand('%')
        local db = vim.b.db
        cmd.edit(vim.b.db_input)
        vim.defer_fn(function()
          k.set('n', '<space>ta', function()
            cmd.edit(dbout)
          end, { buffer = true })
          k.set('n', 'q', '<c-w>q', { buffer = true })
          vim.b.db = db
        end, 100)
      end, { buffer = true })
    end,
  })
end

-- set up dadbod connections
function l.load_connections()
  local config = require('config')
  for _, connection in pairs(config.get('dadbod.connections', {})) do
    local name = connection.name
    local uri = connection.uri
    g[name] = uri
  end
end

function l.db_with_warning(whole)
  local db = b.db or ''
  local db_selected = b.db_selected or ''
  local firstline = fn.line("'<")
  local lastline = fn.line("'>")
  if whole then
    firstline = 1
    lastline = fn.line('$')
  end

  if firstline == 0 then
    print('No query selected')
  end

  if db == '' then
    print('No DB selected')
    return
  elseif db_selected == '' then
    vim.notify('Unknown DB selected, be careful what you are doing.')
  elseif db_selected:match('_prod$') then
    vim.notify('Production DB selected, be careful what you are doing.')
  end

  local has_change = false
  for _, line in ipairs(fn.getline(firstline, lastline)) do
    local checks = {
      ' insert ',
      '^insert ',
      ' insert$',
      ' update ',
      '^update ',
      ' update$',
      ' delete ',
      '^delete ',
      ' delete$',
      ' upsert ',
      '^upsert ',
      ' upsert$',
      ' truncate ',
      '^truncate ',
      ' truncate$',
      ' alter ',
      '^alter ',
      ' alter$',
      ' drop ',
      '^drop ',
      ' drop$',
    }
    if not line:match('^%s*%-%-') then -- skip if comment
      for _, pattern in ipairs(checks) do
        if line:lower():match(pattern) then
          has_change = true
        end
      end
    end
  end

  local halt = false -- perform query
  if has_change then
    halt = 1
      ~= fn.confirm('You are about to do some changes, are you sure you know what you are doing?', 'Yes\nNo', 'No')
    if not halt and db_selected:match('_prod$') then
      halt = 1
        ~= fn.confirm('You know this is Production DB right? Are you sure you want to continue?', 'Yes\nNo', 'No')
    end
  end

  if not halt then
    fn['db#execute_command']('', false, firstline, lastline, '')
  end
end

k.set('n', '<plug>(dadbod-select-database)', function()
  local actions = require('telescope.actions')
  local finders = require('telescope.finders')
  local pickers = require('telescope.pickers')
  local action_state = require('telescope.actions.state')
  local conf = require('telescope.config').values
  l.load_connections()
  pickers
    .new({
      prompt_title = 'Database',
      finder = finders.new_table({
        results = vim.fn['db#url_complete']('g:') or {},
        -- entry_maker = ''
      }),
      sorter = conf.file_sorter({}),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          if selection == nil then
            print('[telescope] Nothing currently selected')
            return
          end
          actions.close(prompt_bufnr)
          vim.b.db = vim.api.nvim_eval(selection[1])
          vim.b.db_selected = selection[1]
          vim.schedule(function()
            vim.fn['db#adapter#ssh#create_tunnel'](vim.b.db)
          end)
        end)
        return true
      end,
    })
    :find()
end)

return l
