local u = require('utils')

local function config()
  local cmp = require('cmp')
  local luasnip = require('luasnip')
  local projector = require('plugins.projector')

  local src = {
    lsp = { name = 'nvim_lsp' },
    lua = { name = 'nvim_lua' },
    ts = { name = 'treesitter' },
    db = { name = 'vim-dadbod-completion' },
    tn = { name = 'cmp_tabnine' },
    snip = { name = 'luasnip', keyword_length = 2 },
    path = { name = 'path' },
    tag = { name = 'tags', max_item_count = 15 },
    buf = { name = 'buffer' },
    emo = { name = 'emoji' },
  }

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<c-space>'] = cmp.mapping.complete(),
      ['<c-y>S'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }),
      ['<c-o>'] = cmp.mapping(function(_)
        if cmp.visible() then
          cmp.close()
        end
      end),
      ['<tab>'] = cmp.mapping(function(_fallback)
        local entry = cmp.core.view:get_selected_entry()
        if cmp.visible() and entry then
          local item = entry:get_completion_item()
          if
            item.data
            and type(item.data) == 'table'
            and item.data.snippet
            and item.data.snippet.kind == 'snipmate'
          then
            projector.expand_snippet()
          else
            cmp.confirm({
              behavior = cmp.ConfirmBehavior.Replace,
              select = true,
            })
          end
        elseif luasnip.expandable() then
          luasnip.expand()
        else
          -- fallback() -- this is broken for some reason
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes([[	]], true, true, true), 'n', true)
        end
      end, { 'i', 's' }),
    }),
    sources = {
      src.lsp,
      src.ts,
      src.tn,
      src.snip,
      src.path,
      src.tag,
      src.buf,
      src.emo,
    },
    sorting = {
      priority_weight = 2,
    },
    formatting = {
      format = function(entry, vim_item)
        -- fancy icons and a name of kind
        vim_item.kind = require('lspkind').presets.default[vim_item.kind] .. ' ' .. vim_item.kind

        -- set a name for each source
        vim_item.menu = ({
          buffer = '[Buf]',
          nvim_lsp = '[LSP]',
          nvim_lua = '[Lua]',
          cmp_tabnine = '[TN]',
          treesitter = '[TS]',
          snippy = '[Snippy]',
          luasnip = '[LSnip]',
          path = '[Path]',
          emoji = '[Emoji]',
          tags = '[Tag]',
          spell = '[Spell]',
          ['vim-dadbod-completion'] = '[DB]',
        })[entry.source.name]
        return vim_item
      end,
    },
  })
  local augroup = vim.api.nvim_create_augroup('x_cmp', { clear = true })
  vim.api.nvim_create_autocmd('FileType', {
    group = augroup,
    pattern = 'sql,mysql,plsql',
    callback = function()
      cmp.setup.buffer({
        sources = {
          src.db,
          src.lsp,
          src.ts,
          src.tn,
          src.snip,
          src.path,
          src.buf,
          src.emo,
        },
      })
    end,
  })
  vim.api.nvim_create_autocmd('FileType', {
    group = augroup,
    pattern = 'lua',
    callback = function()
      cmp.setup.buffer({
        sources = {
          src.lua,
          src.lsp,
          src.ts,
          src.tn,
          src.snip,
          src.path,
          src.buf,
          src.emo,
        },
      })
    end,
  })
end

local function setup() end

return {
  config = config,
  setup = setup,
}
