{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf types;
  cfg = config.nvim.tools.git;
in {
  options.nvim.tools = {
    git = {
      enable = mkEnableOption {
        description = "Enable GitSigns plugin.";
        type = types.bool;
        default = true;
      };
    };
  };

  config.nvim = mkIf cfg.enable {
    startPlugins = with pkgs.neovimPlugins; [gitsigns-nvim];

    nnoremap = {
      "<leader>hs" = ":Gitsigns stage_hunk<CR>";
      "<leader>hr" = ":Gitsigns reset_hunk<CR>";
      "<leader>hS" = "<cmd>Gitsigns stage_buffer<CR>";
      "<leader>hu" = "<cmd>Gitsigns undo_stage_hunk<CR>";
      "<leader>hR" = "<cmd>Gitsigns reset_buffer<CR>";
      "<leader>hp" = "<cmd>Gitsigns preview_hunk<CR>";
      "<leader>hb" = "<cmd>lua require'gitsigns'.blame_line{full=true}<CR>";
      "<leader>tb" = "<cmd>Gitsigns toggle_current_line_blame<CR>";
      "<leader>hd" = "<cmd>Gitsigns diffthis<CR>";
      "<leader>hD" = "<cmd>lua require'gitsigns'.diffthis('~')<CR>";
      "<leader>td" = "<cmd>Gitsigns toggle_deleted<CR>";
    };

    vnoremap = {
      "<leader>hs" = ":Gitsigns stage_hunk<CR>";
      "<leader>hr" = ":Gitsigns reset_hunk<CR>";
    };

    rawConfig = ''
      -- GITSIGNS
      require('gitsigns').setup({
        watch_gitdir = { interval = 100, follow_files = true },
        current_line_blame = true,
        update_debounce = 50,
      })
      -- END GITSIGNS
    '';
  };
}
