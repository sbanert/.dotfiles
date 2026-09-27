return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function ()
    vim.opt.timeout = true
    vim.opt.timeoutlen = 300
  end,
  config = function ()
    require("which-key").setup()
    require("which-key").add {
      { "<leader>b", group = "[B]uffer" },
      { "<leader>b_", hidden = true },
      { "<leader>f", group = "[F]ile" },
      { "<leader>f_", hidden = true },
      { "<leader>g", group = "[G]it" },
      { "<leader>g_", hidden = true },
      { "<leader>h", group = "[H]elp" },
      { "<leader>h_", hidden = true },
      { "<leader>l", group = "[L]SP" },
      { "<leader>l_", hidden = true },
      { "<leader>p", group = "[P]ackages" },
      { "<leader>p_", hidden = true },
    }
  end,
}
