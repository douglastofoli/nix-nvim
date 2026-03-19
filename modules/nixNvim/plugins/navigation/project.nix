{ config, ... }:
{
  flake.nixNvimModules.plugins.navigation.project = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    pluginNames = [ "project-nvim" ];

    keymaps = {
      nnoremap = [
        {
          lhs = "<leader>pp";
          rhs = "<cmd>Telescope projects<cr>";
          opts = {
            desc = "Projects";
          };
        }
      ];
    };

    # nixpkgs uses DrKJeff16/project.nvim (module is "project", not "project_nvim")
    extraLua = ''
      require("project").setup({
        patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "mix.exs" },
        lsp = { enabled = true, use_pattern_matching = true },
      })
    '';
  };
}
