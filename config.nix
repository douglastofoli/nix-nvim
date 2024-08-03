{pkgs, ...}: {
  nvim = {
    package = pkgs.neovim-unwrapped;

    lsp = {
      enable = true;
      lang = {
        elixir.enable = true;
      };
    };

    tools = {
      git = {
        enable = true;
      };
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
