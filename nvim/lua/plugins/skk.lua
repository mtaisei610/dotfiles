return {
  { "vim-denops/denops.vim", lazy = false },

  {
    "vim-skk/skkeleton",
    dependencies = { "vim-denops/denops.vim" },
    lazy = false,
    config = function()
      -- toggle in Insert mode
      vim.keymap.set("i", "<C-j>", "<Plug>(skkeleton-toggle)", { silent = true })

      -- basic config (only eggLikeNewline)
      vim.api.nvim_create_autocmd("User", {
        pattern = "skkeleton-initialize-pre",
        callback = function()
          vim.fn["skkeleton#config"]({
            globalDictionaries = { "/usr/share/skk/SKK-JISYO.L" },
            eggLikeNewline = true,
          })
        end,
      })
    end,
  },
}
