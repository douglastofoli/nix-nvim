{ config, ... }:
{
  flake.nixNvimModules.plugins.ui.trouble = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    pluginNames = [ "trouble-nvim" ];

    extraLua = ''
      require("trouble").setup({})
    '';

    keymaps = {
      whichKeyGroups = [
        {
          prefix = "<leader>x";
          group = "diagnostics";
        }
      ];

      nnoremap = [
        {
          lhs = "<leader>xx";
          rhsLua = "function() require('trouble').toggle('diagnostics') end";
          opts = {
            desc = "Workspace diagnostics";
          };
        }
        {
          lhs = "<leader>xd";
          rhsLua = "function() require('trouble').toggle('document_diagnostics') end";
          opts = {
            desc = "Document diagnostics";
          };
        }
        {
          lhs = "<leader>xq";
          rhsLua = "function() require('trouble').toggle('quickfix') end";
          opts = {
            desc = "Quickfix list";
          };
        }
        {
          lhs = "<leader>xl";
          rhsLua = "function() require('trouble').toggle('loclist') end";
          opts = {
            desc = "Location list";
          };
        }
      ];
    };
  };
}
