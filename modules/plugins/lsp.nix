{
  nixNvim.pluginNames = [
    "nvim-lspconfig"
    "nvim-cmp"
    "cmp-nvim-lsp"
    "luasnip"
  ];

  nixNvim.extraPackageNames = [
    "lua-language-server"
    "nil"
    "ripgrep"
    "fd"
  ];

  nixNvim.extraLua = ''
    local lspconfig = require("lspconfig")

    lspconfig.lua_ls.setup({})
    lspconfig.nil_ls.setup({})
  '';
}
