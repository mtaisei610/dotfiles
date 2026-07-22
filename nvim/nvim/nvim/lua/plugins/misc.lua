return {
  {
    "folke/flash.nvim",
    keys = {
      -- disable the mappings that steal Vim's builtin `s`/`S`
      { "s", false, mode = { "n", "x", "o" } },
      { "S", false, mode = { "n", "x", "o" } },
    },
  },
}
