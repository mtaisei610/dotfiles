return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      open_mapping = [[<c-\>]], -- optional default mapping
      direction = "float",
      float_opts = {
        border = "rounded",
        winblend = 0,
      },
    },
    keys = {
      -- explicit "float terminal" toggle
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Terminal (Float)" },

      -- optional: also map Ctrl-\
      { "<C-\\>", "<cmd>ToggleTerm direction=float<cr>", desc = "Terminal (Float)" },
    },
  },
}
