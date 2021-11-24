local lspconfig = require('lspconfig')
local me = {}

function me.setup(opts)
  opts = vim.tbl_deep_extend('keep', opts, {
    cmd = {
      gitpac_path('elixir-lsp/elixir-ls/out/language_server.sh')
    }
    -- settings = {
    --   elixirLS = {
    --     dialyzerEnabled = false;
    --   }
    -- };
  })
  lspconfig.elixirls.setup(opts)
end

return me
