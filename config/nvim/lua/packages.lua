local u = require('utils')

-- NON PLUGINS --
-- Things that are used by neovim but are not plugins (language servers,
-- linters, etc)
-- This script uses external tools to install and update them
-- usage:
-- :so | UpdateExternalPackages
--
local packages = {
  gitpac = {
    'pbogut/emmet-ls',
  },
}

local managers = {
  yarn = {
    install = 'yarn global add {}',
    update = 'yarn global remove {} && yarn global add {}',
  },
  gem = {
    install = 'gem install {}',
    update = 'gem update {}',
  },
  go = {
    install = 'go install {}',
    update = 'go install {}',
  },
  cargo = {
    install = 'cargo install {}',
    update = 'cargo install {}',
  },
  aur = {
    install = 'paru -S {}',
    update = 'paru -Sy {}',
  },
  gitpac = {
    install = 'gitpac {}',
    update = 'gitpac {}',
  },
}

vim.api.nvim_create_user_command('UpdateExternalPackages', function()
  local cmds = {}
  for manager, package_list in pairs(packages) do
    for _, package in pairs(package_list) do
      cmds[#cmds + 1] = managers[manager].update:gsub('%{%}', package)
    end
  end
  u.process_shell_commands(cmds, {
    done = 'done',
    prefix = '[Update]',
  })
end, {})

vim.api.nvim_create_user_command('InstallExternalPackages', function()
  local cmds = {}
  for manager, package_list in pairs(packages) do
    for _, package in pairs(package_list) do
      cmds[#cmds + 1] = managers[manager].install:gsub('%{%}', package)
    end
  end
  u.process_shell_commands(cmds, {
    done = 'done',
    prefix = '[Install]',
  })
end, {})
