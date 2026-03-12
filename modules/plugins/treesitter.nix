{
  nixNvim.pluginNames = [
    "nvim-treesitter"
  ];

  nixNvim.extraLua = ''
    require("nvim-treesitter.configs").setup({
      highlight = { enable = true },
      indent = { enable = true },
    })
  '';
}
