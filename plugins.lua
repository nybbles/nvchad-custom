local plugins = {
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
    "nvim-treesitter/nvim-treesitter",
    init = function()
      require("core.utils").lazy_load "nvim-treesitter"
      require("core.utils").load_mappings "telescope"
    end,
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      local defaults = require "plugins.configs.treesitter"
      local overrides = require "custom.configs.treesitter"
      return vim.tbl_deep_extend("force", defaults, overrides)
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "syntax")
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function()
      local defaults = require "plugins.configs.mason"
      local overrides = {
        ensure_installed = {
          "lua-language-server",
          "pyright",
          "rust-analyzer",
          "codelldb",
          "clangd",
          "buf",
          "buf-language-server",
        },
      }
      return vim.tbl_deep_extend("force", defaults, overrides)
    end,
    config = function(_, opts)
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
    ft = { "java", "python", "lua", "shell", "yaml", "rust", "proto" },
    dependencies = {
      { 'ray-x/guihua.lua',               build = "cd lua/fzy && make" },
      { 'neovim/nvim-lspconfig' },
      { 'nvim-treesitter/nvim-treesitter' },
      { 'microsoft/python-type-stubs', },
    },
    opts = function()
      local util = require("lspconfig").util
      local on_attach = require("navigator.lspclient.attach").on_attach
      return {
        mason = true,
        lsp = {
          disable_lsp = { "pylsp" },
          servers = { "pyright", "jdtls", "rust_analyzer", "clangd", "bufls" },
          pyright = {
            on_attach = on_attach,
            cmd = { "pyright-langserver", "--stdio" },
            filetypes = { "python" },
            flags = { allow_incremental_sync = true, debounce_text_changes = 500 },
            settings = {
              python = {
                analysis = {
                  autoImportCompletions = true,
                  autoSearchPaths = true,
                  useLibraryCodeForTypes = true,
                  disableOrganizeImports = false,
                  diagnosticMode = "workspace",
                  typeCheckingMode = "basic",
                  stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs",
                }
              }
            }
          },
          pylsp = {
            settings = {
              pylsp = {
                plugins = {
                  autopep8 = { enabled = false },
                  rope_autoimport = {
                    enabled = true,
                    memory = false,
                  },
                  rope_completion = {
                    enabled = true,
                    eager = true,
                  },
                  pylsp_mypy = {
                    enabled = true,
                    report_progress = true,
                  },
                  jedi_completion = { fuzzy = true },
                  mccabe = { enabled = false },
                  black = { enabled = true },
                },

              },
            },

          },
          jdtls = {
            filetypes = { "java" },
          },
          clangd = {
            flags = { allow_incremental_sync = true, debounce_text_changes = 500 },
            cmd = {
              "clangd", "--background-index", "--suggest-missing-includes", "--clang-tidy",
              "--header-insertion=iwyu"
            },
            filetypes = { "c", "cpp", "objc", "objcpp" },
            on_attach = function(client)
              client.resolved_capabilities.document_formatting = true
              on_attach(client)
            end
          },
          rust_analyzer = {
            root_dir = function(fname)
              return util.root_pattern("Cargo.toml", "rust-project.json", ".git")(fname)
                  or util.path.dirname(fname)
            end,
            filetypes = { "rust" },
            message_level = vim.lsp.protocol.MessageType.error,
            on_attach = on_attach,
            settings = {
              ["rust-analyzer"] = {
                assist = { importMergeBehavior = "last", importPrefix = "by_self" },
                cargo = { loadOutDirsFromCheck = true },
                procMacro = { enable = true }
              }
            },
            flags = { allow_incremental_sync = true, debounce_text_changes = 500 }
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
        hover = {
          enabled = false,
        },
        signature = {
          enabled = false,
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
  },
  {
    "simrat39/rust-tools.nvim",
    ft = { "rust" },
    opts = function()
      local result = {
        tools = {
          runnables = {
            use_telescope = true,
          },
          inlay_hints = {
            auto = true,
          },
        },
        server = {
          on_attach = function(client, bufnr)
            require('navigator.lspclient.mapping').setup({ client = client, bufnr = bufnr }) -- setup navigator keymaps here,
            require("navigator.dochighlight").documentHighlight(bufnr)
            require('navigator.codeAction').code_action_prompt(bufnr)

            local rt = require("rust-tools")
            -- Hover actions
            vim.keymap.set("n", "<leader>lh", rt.hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            vim.keymap.set("n", "<leader>ca", rt.code_action_group.code_action_group, { buffer = bufnr })
          end,
        },
      }
      return result
    end,
    config = function(_, opts)
      require("rust-tools").setup(opts)
    end,
  },
  {
    "p00f/clangd_extensions.nvim",
    ft = { "rust" },
    opts = function()
      local result = {
        server = {
          on_attach = function(client, bufnr)
            require('navigator.lspclient.mapping').setup({ client = client, bufnr = bufnr }) -- setup navigator keymaps here,
            require("navigator.dochighlight").documentHighlight(bufnr)
            require('navigator.codeAction').code_action_prompt(bufnr)
          end,
        },
      }
      return result
    end,
    config = function(_, opts)
      require("clangd_extensions").setup(opts)
    end,
  },
}

return plugins
