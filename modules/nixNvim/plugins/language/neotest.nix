{ config, ... }:
{
  flake.nixNvimModules.plugins.language.neotest = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    pluginNames = [
      "neotest"
      "neotest-elixir"
    ];

    extraLua = ''
      require("neotest").setup({
        adapters = {
          require("neotest-elixir"),
        },
        output = { open_on_run = true },
        summary = { animated = true },
      })
    '';

    keymaps = {
      nnoremap = [
        {
          lhs = "<leader>mt";
          rhsLua = "function() require('neotest').run.run() end";
          opts = {
            desc = "Run nearest test";
          };
        }
        {
          lhs = "<leader>mT";
          rhsLua = "function() require('neotest').run.run(vim.fn.expand('%')) end";
          opts = {
            desc = "Run file tests";
          };
        }
        {
          lhs = "<leader>ms";
          rhsLua = "function() require('neotest').summary.toggle() end";
          opts = {
            desc = "Test summary";
          };
        }
        {
          lhs = "<leader>mo";
          rhsLua = "function() require('neotest').output_panel.toggle() end";
          opts = {
            desc = "Test output";
          };
        }
      ];
    };
  };
}
