return {
  "windwp/nvim-autopairs",
  opts = function(_, opts)
    local Rule = require("nvim-autopairs.rule")
    opts.fast_wrap = {}
    return opts
  end,
}
