local c = vim.g.colors

vim.api.nvim_set_hl(0, 'sl_dap', {
  fg = c.orange,
  bg = c.base02,
})

return function()
  local dap = require('dap')
  local status = dap.status()
  if status:len() > 0 then
    return '%#sl_dap# (' .. status .. ')'
  end

  return ''
end
