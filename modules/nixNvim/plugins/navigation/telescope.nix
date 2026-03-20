{config, ...}: {
  flake.nixNvimModules.plugins.navigation.telescope = {
    imports = [config.flake.nixNvimModules.plugin];

    enable = true;

    pluginNames = [
      "plenary-nvim"
      "telescope-nvim"
    ];

    extraPackageNames = [
      "fd"
      "ripgrep"
    ];

    extraLua = ''
      local telescope = NixNvim.safe_require("telescope")
      if telescope then
        telescope.setup({})
        pcall(telescope.load_extension, "projects")
      end
    '';
  };
}
