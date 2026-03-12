{
  nixNvim.extraLua = ''
    vim.g.mapleader = " "
    vim.g.maplocalleader = " "

    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.termguicolors = true
    vim.opt.expandtab = true
    vim.opt.shiftwidth = 2
    vim.opt.tabstop = 2
    vim.opt.smartindent = true

    vim.keymap.set("n", "<leader>w", "<cmd>w<cr>")
    vim.keymap.set("n", "<leader>q", "<cmd>q<cr>")
  '';
}
