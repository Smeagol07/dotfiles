local tmux = require('tmuxctl')
local wt = require('git-worktree')
local config = require('config')
local actions = require('actions')
local u = require('utils')
local k = vim.keymap
local Status = require('git-worktree.status')

local git = {}

function git.is_bare()
  local fwt = vim.split(vim.fn.system('git worktree list'), '\n')[1]
  if fwt:sub(#fwt - 5) == '(bare)' then
    return true, fwt:gsub('%(bare%)$', ''):gsub('[ ]*$', '')
  else
    return false, nil
  end
end

wt.switch_worktree = function(worktree_path)
  local is_bare, base_path = git.is_bare()
  if is_bare then
    worktree_path = base_path .. '/' .. worktree_path
  else
    worktree_path = vim.fn.getcwd() .. '/' .. worktree_path
  end

  tmux.switch_to_path(worktree_path)
end

Status.next_status = function(_) end -- this messages are annoying

if vim.fn.filereadable('HEAD') == 1 then
  vim.defer_fn(function()
    local is_bare, bare_path = git.is_bare()
    if is_bare then
      local cwt = bare_path .. '/current_worktree'
      if vim.fn.filereadable(cwt) == 1 then
        local wtpath = vim.fn.readfile(cwt)[1]
        if vim.fn.isdirectory(wtpath) == 1 then
          tmux.switch_to_path(wtpath)
        end
      end
    end
    require('telescope').extensions['tmux-git-worktree'].git_worktrees()
  end, 100)
end

k.set('n', '<space>gl', require('telescope').extensions['tmux-git-worktree'].git_worktrees)
k.set('n', '<space>gk', function()
  local branch_name = vim.fn.input('New worktree name > ')
  if branch_name:len() > 0 then
    wt.create_worktree(branch_name, branch_name)
  end
end)