{pkgs, ...}: {
  nvim = {
    package = pkgs.neovim-unwrapped;

    tools = {
      gitsigns.enable = true;
    };

    ui = {
      statusline = {
        enable = true;
        theme = "dracula";
      };
      whichkey.enable = true;
    };
  };
}
