# Central place for Neovim autocmds (FileType, BufEnter, etc.).
# Uses lib.writeIf; requires nixpkgs.overlays = self.overlays.default in your config.
{ config, lib, ... }:
let
  inherit (lib) optionalString;

  plugins = config.flake.nixNvimModules.plugins or { };
  elixir = (plugins.languages or {}).elixir or { enable = false; };
  which_key = (plugins.navigation or {})."which-key" or { enable = false; };
in
{
  flake.nixNvimModules.plugins.misc.autocmd = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    extraLua = ''
      -- Elixir: mix group + keybinds only in Elixir buffers (only if elixir-tools and which-key are enabled)
      ${optionalString (elixir.enable && which_key.enable) ''
        local elixir_ft = { "elixir", "eelixir", "heex" }
        local function setup_elixir_buf()
          local bufnr = vim.api.nvim_get_current_buf()
          require("which-key").add({ { "<leader>m", group = "mix" } }, { buffer = bufnr })
          vim.keymap.set("n", "<leader>mt", "<cmd>Mix test<cr>", { buffer = bufnr, desc = "Mix test" })
          vim.keymap.set("n", "<leader>mT", function()
            local file = vim.fn.expand("%:p")
            local line = vim.fn.line(".")
            vim.cmd("Mix test " .. file .. ":" .. line)
          end, { buffer = bufnr, desc = "Mix test (cursor)" })
          vim.keymap.set("n", "<leader>mc", "<cmd>Mix compile<cr>", { buffer = bufnr, desc = "Mix compile" })
          vim.keymap.set("n", "<leader>mx", "<cmd>Mix<cr>", { buffer = bufnr, desc = "Mix (tasks)" })
        end
        vim.api.nvim_create_autocmd("FileType", {
          pattern = elixir_ft,
          callback = setup_elixir_buf,
        })
      ''}
    '';
  };
}
