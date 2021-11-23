local u = require('utils')
local function alias(from, to)
  vim.cmd('Alias ' .. from .. ' ' .. to)
end

u.augroup('x_alias', {
  VimEnter = {'*', function()
    alias('ag', 'Ag')
    alias('agg', 'Agg')
    alias('rg', 'Rg')
    alias('rgg', 'Rgg')
    alias('art', 'Artisan')
    alias('artisan', 'Artisan')
    alias('git', 'Git')
    alias('gan', 'Gan')
    alias('gst', 'Gst')
    alias('gap', 'Gap')
    alias('ge', 'Gedit')
    alias('gedit', 'Gedit')
    alias('grev', 'Grev')
    alias('mix', 'Mix')
    alias('repl', 'Repl')
    alias('skel', 'Skel')
    alias('db', 'DB')
    alias('lg', 'LazyGit')
  end}
})
