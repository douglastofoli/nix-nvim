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
      local telescope = NixNvim.require_plugin("telescope")
      if telescope then
        telescope.setup({
          defaults = {
            preview = {
              -- Avoid the Tree-sitter preview path that errors on Neovim 0.12.
              -- Telescope falls back to Vim syntax highlighting for previews.
              treesitter = false,
            },
          },
        })
        pcall(telescope.load_extension, "projects")
      end
    '';
  };
}
