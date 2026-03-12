{ config, ... }:
{
  config.flake.nixNvim.baseLua = ''
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
}
