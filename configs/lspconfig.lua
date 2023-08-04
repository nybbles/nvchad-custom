local configs = require("plugins.configs.lspconfig")
local lspconfig = require "lspconfig"

lspconfig.pyright.setup {
  on_attach = configs.on_attach,
  capabilities = configs.capabilities,
  filetypes = {"python"},
  cmd = {"poetry", "run", "pyright-langserver", "--stdio" },
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'workspace',
      },
    },
  },
}

-- lspconfig.jdtls.setup {
--   on_attach = configs.on_attach,
--   capabilities = configs.capabilities,
--   filetypes = {"java"},
-- }

return lspconfig
