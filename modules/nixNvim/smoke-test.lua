local ok, err = xpcall(function()
  assert(vim.v.errmsg == "", vim.v.errmsg)
  -- Only check enabled components: downstream flakes may disable plugins.
  local modules = {
    ["telescope-nvim"] = "telescope",
    ["nvim-dap"] = "dap",
    ["nvim-dap-ui"] = "dapui",
    ["nvim-treesitter"] = "nvim-treesitter.configs",
    ["nvim-cmp"] = "cmp",
  }
  for _, plugin in ipairs(vim.json.decode(vim.env.NIX_NVIM_SMOKE_PLUGINS)) do
    local module = modules[plugin]
    if module then
      assert(package.loaded[module], module .. " was not initialized")
    end
  end
  assert(type(vim.lsp.config) == "table", "Neovim 0.11 LSP API required")
end, debug.traceback)
if not ok then
  io.stderr:write(err .. "\n")
  vim.cmd("cquit 1")
else
  vim.cmd("qa!")
end
