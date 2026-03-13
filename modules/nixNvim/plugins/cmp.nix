{ config, ... }:
{
  flake.nixNvimModules.plugins.cmp = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    pluginNames = [
      "blink-cmp"
      "luasnip"
    ];

    extraLua = ''
      require("blink.cmp").setup({
        snippets = {
          preset = "luasnip",
        },

        appearance = {
          nerd_font_variant = "mono",
        },

        completion = {
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
          },
          menu = {
            auto_show = true,
          },
        },

        keymap = {
          preset = "default",

          ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
          
          ["<C-j>"] = {
            "select_next",
            "snippet_forward",
            "fallback",
          },

          ["<C-k>"] = {
            "select_prev",
            "snippet_backward",
            "fallback",
          },
          
          ["<C-y>"] = { "accept", "fallback" },
          ["<C-e>"] = { "hide", "fallback" },
        },

        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
        },

        fuzzy = {
          implementation = "prefer_rust_with_warning",
        },

        signature = {
          enabled = true,
        },
      })
    '';
  };
}
