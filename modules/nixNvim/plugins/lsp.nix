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
      vim.lsp.config("lua_ls", {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
      })
      vim.lsp.config("nil_ls", {
        cmd = { "nil" },
        filetypes = { "nix" },
        root_markers = { "flake.nix", ".git" },
      })
      vim.lsp.enable("lua_ls")
      vim.lsp.enable("nil_ls")
    '';
  };
}
