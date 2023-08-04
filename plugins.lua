local plugins = {
  {
    "neovim/nvim-lspconfig",
    init = function()
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = function()
      local defaults = require "plugins.configs.nvimtree"
      local overrides = {
        update_focused_file = {
          update_root = false,
        }
      }
      return vim.tbl_deep_extend("force", defaults, overrides)
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    init = function()
      require("core.utils").load_mappings "telescope"
    end,
    opts = function()
      local defaults = require "plugins.configs.telescope"
      local overrides = {
        extensions_list = {
          "themes", "terms",
        }
      }
      return vim.tbl_deep_extend("force", defaults, overrides)
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function ()
      local defaults =  require "plugins.configs.mason"
      local overrides =  {
        ensure_installed = {
          "lua-language-server",
          "pyright",
        },
      }
      return vim.tbl_deep_extend("force", defaults, overrides)
    end ,
    config = function (_, opts)
      dofile(vim.g.base46_cache .. "mason")
      require("mason").setup(opts)

      vim.api.nvim_create_user_command("MasonInstallAll", function()
        vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
      end, {})

      vim.g.mason_binaries_list = opts.ensure_installed

      require("mason-lspconfig").setup({})
    end,
    dependencies = {
      { 'williamboman/mason-lspconfig.nvim' },
    },
  },
  {
    "ray-x/navigator.lua",
    ft = { "java", "python", "lua", "shell", "yaml" },
    dependencies = {
      { 'ray-x/guihua.lua', build = "cd lua/fzy && make" },
      { 'neovim/nvim-lspconfig' },
      { 'nvim-treesitter/nvim-treesitter' },
    },
    opts = function ()
      local on_attach = require("navigator.lspclient.attach").on_attach
      return {
        mason = true,
        lsp = {
          servers = {"pyright"},
          pyright = {
            on_attach = on_attach,
            cmd = {"pyright-langserver", "--stdio"},
            filetypes = {"python"},
            flags = {allow_incremental_sync = true, debounce_text_changes = 500},
            settings = {
              python = {
                analysis = {
                  autoSearchPaths = true,
                  useLibraryCodeForTypes = true,
                  diagnosticMode = "workspace"
                }
              }
            }
          },
        },
      }
    end,
    config = function(_, opts)
      require("navigator").setup(opts)
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true,        -- add a border to hover docs and signature help
      },
      views = {
        cmdline_popup = {
          position = {
            row = 5,
            col = "50%",
          },
          size = {
            width = 60,
            height = "auto",
          },
        },
        popupmenu = {
          relative = "editor",
          position = {
            row = 8,
            col = "50%",
          },
          size = {
            width = 60,
            height = 10,
          },
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
          },
        },
      }
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    }
  }
}

return plugins