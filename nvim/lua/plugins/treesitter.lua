return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "typescript",
        "tsx",
        "javascript",
        "html",
        "css",
        "json",
        "python",
        "django", -- template support if available in your TS parser set
      })
      opts.indent = { enable = true }
    end,
  },
}
