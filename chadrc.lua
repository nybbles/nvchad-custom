local M = {}

vim.o.guifont = "UbuntuMono Nerd Font Mono:h14"

M.ui = {
  theme = 'ayu_light',
  theme_toggle = { 'ayu_dark', 'ayu_light' },
}
M.mappings = require "custom.mappings"
M.plugins = "custom.plugins"

return M
