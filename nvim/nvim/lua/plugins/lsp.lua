if vim.g.vscode then
  return {}
end

local getPythonPath = function()
  local config_path = vim.fn.getcwd() .. "/pyrightconfig.json"
  if vim.fn.filereadable(config_path) == 1 then
    local f = io.open(config_path, "r")
    if f then
      local content = f:read("*a")
      f:close()
      local ok, decoded = pcall(vim.fn.json_decode, content)
      if ok and decoded.pythonPath then
        return decoded.pythonPath
      end
    end
  end
  -- INFO: For uv(python project manager)
  local venv_exe = vim.fn.getcwd() .. "/.venv/bin/python"
  if vim.fn.executable(venv_exe) == 1 then
    return venv_exe
  end
  -- default
  return "python"
end
vim.g.python3_host_prog = getPythonPath()

-- HACK: Normal
return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.servers = opts.servers or {}

    -- INFO: For python
    opts.servers.pyright = {
      settings = {
        python = {
          pythonPath = getPythonPath(),
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "workspace",
          },
        },
      },
    }
    opts.servers.ruff = {
      init_options = {
        settings = {
          interpreter = { getPythonPath() },
        },
      },
    }
  end,
}
