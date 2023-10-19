local options = {
  ensure_installed = { "lua", "python", "rust", "yaml", "toml", "regex", "bash", "markdown", "markdown_inline", },
  auto_install = true,

  highlight = {
    enable = true,
    use_languagetree = true,
  },

  indent = { enable = true },

  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  },
}

return options
