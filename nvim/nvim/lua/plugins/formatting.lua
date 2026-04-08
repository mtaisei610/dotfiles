return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- Next.js / frontend
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        markdown = { "prettier" },

        -- Django / Python
        python = { "ruff_format" }, -- or { "black" }
      },
    },
  },
}
