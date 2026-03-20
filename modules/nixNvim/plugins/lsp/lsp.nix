{
  config,
  lib,
  ...
}: let
  servers = {
    lua_ls = {
      packageName = "lua-language-server";
      cmd = [
        "lua-language-server"
      ];
      filetypes = ["lua"];
      rootMarkers = [
        ".luarc.json"
        ".luarc.jsonc"
        ".git"
      ];
    };
    nil_ls = {
      packageName = "nil";
      cmd = ["nil"];
      filetypes = ["nix"];
      rootMarkers = [
        "flake.nix"
        ".git"
      ];
    };
    expert = {
      packageName = null;
      cmd = [
        "expert"
        "--stdio"
      ];
      filetypes = [
        "elixir"
        "eelixir"
        "heex"
      ];
      rootMarkers = [
        "mix.exs"
        ".git"
      ];
    };
  };

  mkLuaList = values: "{ " + lib.concatStringsSep ", " (map (v: "\"${v}\"") values) + " }";

  mkServerConfigLua = name: server: ''
    vim.lsp.config("${name}", {
      cmd = ${mkLuaList server.cmd},
      filetypes = ${mkLuaList server.filetypes},
      root_markers = ${mkLuaList server.rootMarkers},
    })
  '';

  serverNames = builtins.attrNames servers;
  managedPackages = lib.filter (p: p != null) (map (name: servers.${name}.packageName) serverNames);
  lspConfigLua = lib.concatStringsSep "\n\n" (map (name: mkServerConfigLua name servers.${name}) serverNames);
  lspEnableLua = lib.concatStringsSep "\n" (map (name: ''vim.lsp.enable("${name}")'') serverNames);
in {
  flake.nixNvimModules.plugins.lsp.lsp = {
    imports = [config.flake.nixNvimModules.plugin];

    enable = true;

    pluginNames = [
      "nvim-lspconfig"
    ];

    extraPackageNames = managedPackages;

    extraLua = ''
      ${lspConfigLua}

      ${lspEnableLua}
    '';

    keymaps = {
      nnoremap = [
        {
          lhs = "gd";
          rhsLua = "vim.lsp.buf.definition";
          opts = {desc = "Definition";};
        }
        {
          lhs = "gD";
          rhsLua = "vim.lsp.buf.declaration";
          opts = {desc = "Declaration";};
        }
        {
          lhs = "gi";
          rhsLua = "vim.lsp.buf.implementation";
          opts = {desc = "Implementation";};
        }
        {
          lhs = "K";
          rhsLua = "vim.lsp.buf.hover";
          opts = {desc = "Hover docs";};
        }
        {
          lhs = "[d";
          rhsLua = "vim.diagnostic.goto_prev";
          opts = {desc = "Prev diagnostic";};
        }
        {
          lhs = "]d";
          rhsLua = "vim.diagnostic.goto_next";
          opts = {desc = "Next diagnostic";};
        }
      ];
    };
  };
}
