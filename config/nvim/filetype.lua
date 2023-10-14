-- vim.g.do_filetype_lua = 1
-- vim.g.did_load_filetypes = 0
vim.filetype.add({
  extension = {
    conf = 'conf',
    env = 'dotenv',
  },
  filename = {
    ['.env'] = 'dotenv',
    ['env'] = 'dotenv',
    ['tsconfig.json'] = 'jsonc',
    ['.yamlfmt'] = 'yaml',
  },
  pattern = {
    ['%.?env%.[%w_%..-]+'] = 'dotenv',
    ['.*/waybar/config'] = 'jsonc',
  },
})
