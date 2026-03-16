# Shared keymaps submodule type. Used by options.nix (flake.nixNvim.keymaps) and plugin.nix (per-plugin keymaps).
# Sections: nnoremap, inoremap, vnoremap, snoremap, nmap, imap, vmap, smap.
{ lib }:
let
  keymapEntry = lib.types.submodule {
    options = {
      lhs = lib.mkOption {
        type = lib.types.str;
        description = "LHS key combo (e.g. <leader>ff).";
      };
      rhs = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "RHS command string (e.g. <cmd>Telescope find_files<cr>). Ignored when rhsLua is set.";
      };
      rhsLua = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "RHS as Lua code (e.g. function() ... end or vim.lsp.buf.rename). When set, rhs is ignored.";
      };
      opts = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        default = { };
        description = "Extra options for vim.keymap.set (e.g. desc, silent).";
      };
    };
  };

  keymapSection = lib.types.listOf keymapEntry;

  sections = [
    "nnoremap"
    "inoremap"
    "vnoremap"
    "snoremap"
    "nmap"
    "imap"
    "vmap"
    "smap"
  ];

  whichKeyGroupEntry = lib.types.submodule {
    options = {
      prefix = lib.mkOption {
        type = lib.types.str;
        description = "Key prefix (e.g. <leader>b).";
      };
      group = lib.mkOption {
        type = lib.types.str;
        description = "Which-key group label.";
      };
    };
  };

  keymapsSubmodule = lib.types.submodule {
    options =
      lib.genAttrs sections (
        name:
        lib.mkOption {
          type = keymapSection;
          default = [ ];
          description = "Keymaps for ${name}.";
        }
      )
      // {
        whichKeyGroups = lib.mkOption {
          type = lib.types.listOf whichKeyGroupEntry;
          default = [ ];
          description = "Which-key group labels (require which-key).";
        };
      };
  };
in
{
  inherit keymapsSubmodule sections;
}
