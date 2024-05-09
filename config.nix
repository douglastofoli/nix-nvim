{pkgs, ...}: {
  nvim = {
    package = pkgs.neovim-unwrapped;

    ui = {
      statusline = {
        enable = true;
        theme = "dracula";
      };
      whichkey.enable = true;
    };
  };
}
