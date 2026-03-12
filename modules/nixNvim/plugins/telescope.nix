{ config, ... }:
{
  flake.nixNvimModules.plugins.telescope = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    pluginNames = [
      "plenary-nvim"
      "telescope-nvim"
    ];

    extraLua = ''
      require("telescope").setup({})

      vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
      vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
      vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
    '';
  };
}
