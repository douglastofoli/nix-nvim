{ config, ... }:
{
  config.flake.nixNvim = {
    baseLua = ''
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "

      vim.opt.timeout = true
      vim.opt.timeoutlen = 500

      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.termguicolors = true
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
      vim.opt.tabstop = 2
      vim.opt.smartindent = true
    '';

    keymaps = {
      nnoremap = [
        {
          lhs = "<leader>q";
          rhs = "<cmd>q<cr>";
          opts = {
            desc = "Quit";
          };
        }

        # Toggles
        {
          lhs = "<leader>tn";
          rhsLua = "function() vim.opt.number = not vim.opt.number:get() end";
          opts = {
            desc = "Toggle line numbers";
          };
        }
        {
          lhs = "<leader>tr";
          rhsLua = "function() vim.opt.relativenumber = not vim.opt.relativenumber:get() end";
          opts = {
            desc = "Toggle relative numbers";
          };
        }
        {
          lhs = "<leader>td";
          rhsLua = "function() if vim.diagnostic.is_disabled(0) then vim.diagnostic.enable(0) else vim.diagnostic.disable(0) end end";
          opts = {
            desc = "Toggle diagnostics";
          };
        }
      ];
    };
  };
}
