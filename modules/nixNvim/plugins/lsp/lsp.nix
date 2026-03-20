{ config, ... }:
{
  flake.nixNvimModules.plugins.lsp.lsp = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    pluginNames = [
      "nvim-lspconfig"
    ];

    extraPackageNames = [
      "lua-language-server"
      "nil"
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

      vim.lsp.config('expert', {
        cmd = { 'expert', '--stdio' },
        root_markers = { 'mix.exs', '.git' },
        filetypes = { 'elixir', 'eelixir', 'heex' },
      })

      vim.lsp.enable("lua_ls")
      vim.lsp.enable("nil_ls")
      vim.lsp.enable("expert")
    '';

    keymaps = {
      nnoremap = [
        {
          lhs = "gd";
          rhsLua = "vim.lsp.buf.definition";
          opts = { desc = "Definition"; };
        }
        {
          lhs = "gD";
          rhsLua = "vim.lsp.buf.declaration";
          opts = { desc = "Declaration"; };
        }
        {
          lhs = "gi";
          rhsLua = "vim.lsp.buf.implementation";
          opts = { desc = "Implementation"; };
        }
        {
          lhs = "K";
          rhsLua = "vim.lsp.buf.hover";
          opts = { desc = "Hover docs"; };
        }
        {
          lhs = "[d";
          rhsLua = "vim.diagnostic.goto_prev";
          opts = { desc = "Prev diagnostic"; };
        }
        {
          lhs = "]d";
          rhsLua = "vim.diagnostic.goto_next";
          opts = { desc = "Next diagnostic"; };
        }
      ];
    };
  };
}
