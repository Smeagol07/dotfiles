local execute = vim.api.nvim_command
local fn = vim.fn
local cmd = vim.cmd

local install_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'

local first_install = false

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  first_install = true
end

execute('packadd packer.nvim')

-- reload and recompile this file (plugins.lua) after change
local ag_x_plugins_save = vim.api.nvim_create_augroup('x_plugins_save', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  group = ag_x_plugins_save,
  pattern = 'plugins.lua',
  callback = function()
    cmd.luafile(os.getenv('HOME') .. '/.config/nvim/lua/plugins.lua')
    cmd.PackerClean()
    cmd.PackerInstall()
    cmd.PackerCompile()
  end,
})
vim.api.nvim_create_autocmd('BufEnter', {
  group = ag_x_plugins_save,
  pattern = 'plugins.lua',
  callback = function()
    vim.bo.path = fn.stdpath('config') .. '/lua/plugins/'
  end,
})

local function config(plugin)
  return [[
    local _, xcfg = pcall(require, "plugins.]] .. plugin .. [[")
    if type(xcfg) == 'table' and xcfg['config'] then
      xcfg.config()
    end]]
end

local function setup(plugin)
  return [[
    local _, xcfg = pcall(require, "plugins.]] .. plugin .. [[")
    if type(xcfg) == 'table' and xcfg['setup'] then
      xcfg.setup()
    end]]
end

require('packer').startup({
  function(use)
    -- Packer can manage itself as an optional plugin
    use({ 'wbthomason/packer.nvim', opt = true })

    -- My local plugins
    use({ fn.stdpath('config') .. '/local/projector', config = config('projector') })
    use({ fn.stdpath('config') .. '/local/actions', config = 'require"actions"' })
    use({ fn.stdpath('config') .. '/local/remotesync', config = 'require"remotesync"' })

    -- Github plugins
    use({ 'tpope/vim-scriptease' })
    use({ 'tpope/vim-eunuch' })
    use({ 'tpope/vim-rsi' })
    use({ 'tpope/vim-abolish' }) -- coercion thingis
    use({ 'tpope/vim-repeat' })
    use({ 'tpope/vim-sleuth' })
    use({ 'tpope/vim-rails', ft = { 'ruby' } })
    use({ 'vim-ruby/vim-ruby', ft = { 'ruby' } })
    use({ 'tpope/vim-unimpaired' })
    use({ 'ThePrimeagen/harpoon', config = config('harpoon') })
    use({ 'lambdalisue/suda.vim' })
    use({ 'gioele/vim-autoswap' })
    use({ 'kylechui/nvim-surround', config = config('nvim_surround') })
    use({ 'nvim-lualine/lualine.nvim', config = config('lualine_nvim') })
    use({ 'b0o/incline.nvim', config = config('incline_nvim') })
    use({ 'kyazdani42/nvim-web-devicons', config = config('nvim_web_devicons') })
    use({ 'mfussenegger/nvim-dap', config = config('nvim_dap') })
    use({ 'mhinz/vim-signify', config = config('vim_signify') })
    use({ 'ntpeters/vim-better-whitespace', config = config('vim_better_whitespace') })
    use({ 'honza/vim-snippets' })
    use({ 'andymass/vim-matchup', config = [[
      vim.g.matchup_matchparen_offscreen = {}
    ]]})
    use({
      'vim-test/vim-test',
      cmd = { 'TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestLast', 'TestVisit' },
      config = config('vim_test'),
      setup = setup('vim_test'),
    })
    use({ 'elmcast/elm-vim', ft = { 'elm' } })
    use({ 'pbogut/vim-elmper', ft = { 'elm' } })
    use({ 'elixir-lang/vim-elixir', ft = { 'elixir', 'eelixir' } })
    use({ 'moll/vim-bbye', cmd = { 'Bdelete', 'Bwipeout' }, setup = setup('vim_bbye') })
    use({ 'will133/vim-dirdiff', cmd = 'DirDiff', config = config('vim_dirdiff') })
    use({
      'dbakker/vim-projectroot',
      config = [[
        vim.g.rootmarkers = {'.projectroot', '.git', '.hg', '.svn', '.bzr',
                             '_darcs', 'build.xml', 'composer.json', 'mix.exs'}
      ]],
    })
    use({ 'AndrewRadev/switch.vim', config = config('switch_vim') })
    use({ 'AndrewRadev/splitjoin.vim' })
    use({ 'AndrewRadev/sideways.vim', config = config('sideways_vim') })
    use({ 'vim-scripts/cmdalias.vim', config = config('cmdalias_vim') })
    use({ 'Shougo/echodoc.vim' })
    use({
      'justinmk/vim-dirvish',
      config = config('vim_dirvish'),
      requires = { 'kristijanhusak/vim-dirvish-git' },
    })
    use({ 'justinmk/vim-sneak', config = config('vim_sneak') })
    use({ 'vim-scripts/ReplaceWithRegister', config = config('replacewithregister') })
    use({ 'kana/vim-textobj-user' })
    use({ 'beloglazov/vim-textobj-quotes', after = 'vim-textobj-user' })
    use({ 'MattesGroeger/vim-bookmarks', config = config('vim_bookmarks') })
    use({ 'rrethy/vim-illuminate' })
    use({ 'rcarriga/nvim-notify', config = config('nvim_notify') })
    use({ 'lukas-reineke/indent-blankline.nvim', config = config('indent_blankline') })
    use({
      'nvim-telescope/telescope.nvim',
      config = config('telescope_nvim'),
      requires = { 'nvim-lua/plenary.nvim' },
    })
    use({ 'nvim-telescope/telescope-ui-select.nvim' })
    use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })
    use({
      'tpope/vim-dadbod',
      cmd = 'DB',
      config = config('vim_dadbod'),
      fn = 'db#url_complete',
      requires = { 'pbogut/vim-dadbod-ssh' },
    })
    use({ 'joosepalviste/nvim-ts-context-commentstring' })
    use({ 'numtostr/comment.nvim', config = config('comment_nvim') })
    use({ 'frankier/neovim-colors-solarized-truecolor-only' })
    use({ 'sirtaj/vim-openscad', opt = false })
    use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', config = config('nvim_treesitter') })

    -- git
    use({
      'timuntersberger/neogit',
      config = config('neogit'),
      setup = setup('neogit'),
      cmd = { 'Neogit', 'Gst' },
      requires = { 'nvim-lua/plenary.nvim' },
    })
    use({ 'rhysd/git-messenger.vim', config = config('git_messanger') })

    -- completion
    use({ 'dcampos/nvim-snippy', after = 'projector', config = config('nvim_snippy') })
    use({ 'tzachar/cmp-tabnine', run = './install.sh', after = 'nvim-cmp' })
    use({
      'hrsh7th/nvim-cmp',
      after = { 'nvim-snippy', 'projector' },
      config = config('nvim_cmp'),
      setup = setup('nvim_cmp'),
      requires = {
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-emoji',
        'tzachar/cmp-tabnine',
        'ray-x/cmp-treesitter',
        'onsails/lspkind-nvim',
        'dcampos/cmp-snippy',
        'kristijanhusak/vim-dadbod-completion',
        -- 'quangnguyen30192/cmp-nvim-tags', # dont even try, its slow trash
      },
    })
    -- copilot after rsi due to binding conflict (<c-f>)
    -- lsp
    use({ 'ray-x/lsp_signature.nvim' })
    use({
      'jose-elias-alvarez/null-ls.nvim',
      config = config('null_ls_nvim'),
      requires = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    })
    use({ 'folke/trouble.nvim', config = config('trouble_nvim') })
    use({ 'neovim/nvim-lspconfig', config = config('nvim_lsp') })
    use({ 'smiteshp/nvim-gps', config = config('nvim_gps') })
    if vim.fn.filereadable((os.getenv('HOME') or '') .. '/.wakatime.cfg') > 0 then
      use({ 'wakatime/vim-wakatime' })
    end
    use({ 'activitywatch/aw-watcher-vim' })
  end,
})

if first_install then
  require('packages')
  cmd.InstallExternalPackages()
  cmd.PackerInstall()
  cmd.PackerCompile()
end
