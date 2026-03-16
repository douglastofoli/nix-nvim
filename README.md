<h2 align="center">
  <picture>
    <img src="assets/logo.png" width="25%" />
  </picture>

  Nix Nvim
</h2>

A configurable Neovim derivation for Nix and NixOS, built with [flake-parts](https://github.com/hercules-ci/flake-parts) and [import-tree](https://github.com/vic/import-tree). Configuration follows a **dendritic pattern**: modules live under `flake.nixNvimModules` (e.g. `base`, `plugin`, `plugins.navigation.telescope`) and are imported from the directory tree via `import-tree`.

## Features

- **Overlay** for NixOS: add the flake overlay and install `pkgs.neovim` (overlay uses `self.packages.${system}.neovim`)
- **devShell**: run `nix develop` to get a shell with the configured Neovim and runtime deps on PATH
- **Dendritic layout**: `flake.nixNvimModules.base`, `flake.nixNvimModules.plugin`, `flake.nixNvimModules.plugins.<category>.<name>` map to the `modules/nixNvim/` tree
- **Nested plugin modules**: Plugins can be flat or nested (e.g. `plugins.ui.theme`, `plugins.editing.autopairs`). The aggregator flattens the tree and merges into the main config; each plugin can set `enable = false`
- **Declarative keymaps**: Global and per-plugin keymaps (nnoremap, inoremap, etc.) with optional **which-key** group labels; Lua is generated and injected in init order
- **Structured init order**: Base Lua → plugin Lua → keymaps (which-key + vim.keymap.set) → autocmds

## Requirements

- Nix with flakes enabled
- Inputs: `nixpkgs`, `nixpkgs-stable` (optional; used for nvim-treesitter withAllGrammars), `flake-parts`, `import-tree` (declared in the flake)

## Quick start

### Run Neovim (from this repo)

```bash
nix run .#neovim
# or
nix develop -c nvim
```

### Use as overlay in NixOS

Add the flake to your inputs and use the overlay:

```nix
# flake.nix
{
  inputs.nix-nvim.url = "path:/path/to/nix-nvim";  # or git ref

  outputs = { nixpkgs, nix-nvim, ... }: {
    nixosConfigurations.host = nixpkgs.lib.nixosSystem {
      modules = [
        {
          nixpkgs.overlays = [ nix-nvim.overlays.default ];
          environment.systemPackages = [ pkgs.neovim ];
        }
      ];
    };
  };
}
```

With the overlay applied, the package is available as `pkgs.neovim`. Add it to `environment.systemPackages` in your NixOS config (e.g. `configuration.nix`) if not already set in the module above.

### devShell

```bash
nix develop
# then: nvim
```

The devShell includes the Neovim derivation plus all runtime dependencies (`extraPackageNames` / `extraPackages`) on PATH.

## Architecture

### Init Lua order

Init Lua is assembled in `package.nix` in this order:

1. **baseLua** – Leader, timeout, number/relativenumber, colors, indent (set by `base.nix`)
2. **extraLuaPlugins** – Concatenated Lua from all enabled plugin modules (set by `plugins-aggregate.nix`)
3. **extraLuaKeymaps** – which-key groups and `vim.keymap.set` calls (set by `keymaps.nix` from global and plugin keymaps)
4. **extraLuaAutocmds** – Autocmds (e.g. FileType); set by modules like `plugins.misc.autocmd`

The option `extraLua` exists but is not used when building init; use plugin modules or `baseLua` / `extraLuaAutocmds` instead.

### Keymaps

- **Global keymaps**: `config.flake.nixNvim.keymaps` in `base.nix` (and overridable elsewhere)
- **Per-plugin keymaps**: Each plugin module can set `keymaps` (same shape); `keymaps.nix` collects from the main config and all enabled plugins, then emits Lua.
- **Sections**: `nnoremap`, `inoremap`, `vnoremap`, `snoremap`, `nmap`, `imap`, `vmap`, `smap` (see `lib/keymaps-type.nix`).
- **Entries**: `lhs`, `rhs` (string), optional `rhsLua` (Lua code), and `opts` (e.g. `desc`, `silent`) for `vim.keymap.set`.
- **which-key**: Optional `keymaps.whichKeyGroups` (list of `{ prefix, group }`); when which-key is enabled, groups are registered so keymaps show under the right labels.

### Plugin tree and aggregator

- **Tree**: `flake.nixNvimModules.plugins` can be flat (`plugins.gitsigns`) or nested (`plugins.ui.dracula`, `plugins.editing.autopairs`). Nested attrs are flattened; only attrs that have `pluginNames` are treated as plugin configs.
- **plugins-aggregate.nix**: Merges all enabled plugin configs into `flake.nixNvim` (`pluginNames`, `extraPackageNames`, `extraLuaPlugins`, `extraVim`).
- **Per-plugin options**: Each plugin imports `config.flake.nixNvimModules.plugin` and can set `enable`, `pluginNames`, `extraPackageNames`, `extraLua`, `extraVim`, and `keymaps`.

## Project layout

```
.
├── flake.nix              # Flake entry; uses import-tree ./modules
├── overlay.nix            # Nixpkgs overlay (exposes neovim from self.packages)
├── README.md
├── lib/
│   └── keymaps-type.nix   # keymaps submodule type (sections, whichKeyGroups)
└── modules/
    └── nixNvim/
        ├── base.nix           # flake.nixNvimModules.base (baseLua, base keymaps)
        ├── keymaps.nix        # Collects keymaps → extraLuaKeymaps
        ├── options.nix        # options.flake.nixNvim, flake.nixNvimModules
        ├── package.nix        # Builds derivation and devShell (perSystem); init order
        ├── plugin.nix         # flake.nixNvimModules.plugin (option template)
        ├── plugins-aggregate.nix  # Merges plugins.* into flake.nixNvim
        └── plugins/
            ├── plugin.nix     # Template imported by each plugin
            ├── completion/
            │   └── cmp.nix
            ├── editing/
            │   ├── autopairs.nix
            │   ├── comment.nix   (kommentary)
            │   └── format.nix
            ├── git/
            │   └── gitsigns.nix
            ├── language/
            │   └── treesitter.nix
            ├── languages/
            │   └── elixir.nix
            ├── lsp/
            │   └── lsp.nix
            ├── misc/
            │   ├── autocmd.nix
            │   └── notify.nix
            ├── navigation/
            │   ├── neo-tree.nix
            │   ├── telescope.nix
            │   └── which-key.nix
            └── ui/
                ├── indent-blankline.nix
                ├── lualine.nix
                ├── theme.nix    (dracula)
                └── web-devicons.nix
```

- **import-tree** imports every `.nix` under `modules/`; the directory structure under `modules/nixNvim/` mirrors the option path `flake.nixNvimModules.*`.
- **options.nix** defines `flake.nixNvim` (main config) and `flake.nixNvimModules` (module set).
- **package.nix** builds the Neovim derivation and devShell in `perSystem`, resolves `pluginNames` and `extraPackageNames` with `pkgs`, and assembles init from `baseLua`, `extraLuaPlugins`, `extraLuaKeymaps`, `extraLuaAutocmds`.

## Configuration options

Under `config.flake.nixNvim` (or the option `flake.nixNvim`):

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | bool | `true` | Whether to build the package and devShell. |
| `packageName` | string | `"neovim"` | Name of the package and app (and store path). |
| `plugins` | listOf package | `[]` | Plugin packages (can also be filled via `pluginNames`). |
| `pluginNames` | listOf string | `[]` | Vim plugin names (e.g. `nvim-lspconfig`) resolved with `pkgs.vimPlugins`. |
| `extraPackages` | listOf package | `[]` | Extra packages on PATH. |
| `extraPackageNames` | listOf string | `[]` | Extra package names (e.g. `lua-language-server`) resolved with `pkgs`. |
| `baseLua` | lines | `""` | Lua run first (leader, options). Set by base.nix. |
| `extraLua` | lines | `""` | Not used in init assembly; use plugin modules or baseLua/extraLuaAutocmds. |
| `extraLuaPlugins` | lines | (internal) | Lua from plugins; set by plugins-aggregate. |
| `extraLuaKeymaps` | lines | (internal) | Lua for keymaps; set by keymaps.nix. |
| `extraLuaAutocmds` | lines | `""` | Lua for autocmds (run last). Set by e.g. misc/autocmd.nix. |
| `keymaps` | keymaps submodule | `{}` | Global keymaps (nnoremap, inoremap, …) and optional whichKeyGroups. |
| `extraVim` | lines | `""` | Vimscript appended to the config. |
| `viAlias` / `vimAlias` | bool | `true` | Create `vi`/`vim` aliases. |
| `withNodeJs` / `withPython3` / `withRuby` | bool | varies | Provider support. |

Plugin modules set `flake.nixNvimModules.plugins.<category>.<name>` with `pluginNames`, `extraPackageNames`, `extraLua`, `extraVim`, `keymaps`, and optional `enable`; the aggregator and keymaps module merge them into the main config.

## Adding a plugin module

1. Create a file under `modules/nixNvim/plugins/`, e.g. `modules/nixNvim/plugins/ui/mytheme.nix` for `flake.nixNvimModules.plugins.ui.mytheme`.
2. Set the option and import the plugin template:

```nix
{ config, ... }:
{
  flake.nixNvimModules.plugins.ui.mytheme = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    pluginNames = [ "my-theme" ];
    extraPackageNames = [ ];  # optional
    extraLua = '' ... '';
    extraVim = '' ... '';     # optional
    keymaps = { nnoremap = [ { lhs = "<leader>ct"; rhs = "<cmd>Colorscheme mytheme<cr>"; opts = { desc = "My theme"; }; } ]; };
  };
}
```

3. No need to register the file; `import-tree` picks it up and the aggregator will include it when `enable` is true.

## Flake outputs

- **packages.***system*.**neovim** / **default** – Neovim derivation
- **apps.***system*.**neovim** / **default** – Run Neovim
- **devShells.***system*.**default** – Shell with `neovim` and runtime deps on PATH
- **overlays.default** – Nixpkgs overlay (use in NixOS as above)

## Why `nixNvimModules` instead of `flake.modules.nixNvim`?

`flake.modules` is reserved by flake-parts for the list of NixOS modules that configure the flake. To avoid a clash, this flake uses **flake.nixNvimModules** for the dendritic module tree (base, plugin, plugins.*). The main config remains **flake.nixNvim**.

## License

See repository or specify your license here.
