local M = {}

M.general = {
  n = {
    ["<leader>ts"] = {
      function()
        require("base46").toggle_theme()
      end,
      "toggle theme",
    },
  },
}

M.portal = {
  n = {
    ["<leader>o"] = {
      "<cmd>Portal jumplist backward<cr>",
    },
    ["<leader>i"] = {
      "<cmd>Portal jumplist forward<cr>",
    },
  },
}


M.grapple = {
  n = {
    ["<leader>ma"] = {
      function()
        require("grapple").toggle()
      end,
      "Toggle grapple tag"
    },
    ["<leader>ml"] = {
      function()
        -- require("grapple").popup_tags()
        require("portal.builtin").grapple.tunnel()
      end,
      "List grapple tags"
    },
    -- ["<leader>mn"] = {
    --   function ()
    --     require("grapple").select({ key = "{name}" })
    --   end
    -- },
    -- ["<leader>mN"] = {
    --   function ()
    --     require("grapple").toggle({ key = "{name}" })
    --   end
    -- },
  }
}

return M
