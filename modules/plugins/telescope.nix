{
  nixNvim.pluginNames = [
    "plenary-nvim"
    "telescope-nvim"
  ];

  nixNvim.extraLua = ''
    require("telescope").setup({})

    vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
    vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
    vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
  '';
}
