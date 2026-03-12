{ config, ... }:
{
  flake.nixNvimModules.plugins.lsp = {
    imports = [ config.flake.nixNvimModules.plugin ];

    pluginNames = [
      "nvim-lspconfig"
      "nvim-cmp"
      "cmp-nvim-lsp"
      "luasnip"
    ];

    extraPackageNames = [
      "lua-language-server"
      "nil"
      "ripgrep"
      "fd"
    ];

    extraLua = ''
      local lspconfig = require("lspconfig")

      lspconfig.lua_ls.setup({})
      lspconfig.nil_ls.setup({})
    '';
  };
}
