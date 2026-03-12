# nix-nvim

A configurable Neovim derivation for Nix and NixOS, built with [flake-parts](https://github.com/hercules-ci/flake-parts) and [import-tree](https://github.com/vic/import-tree). Configuration follows a **dendritic pattern**: modules live under `flake.nixNvimModules` (e.g. `base`, `plugin`, `plugins.lsp`) and are imported from the directory tree via `import-tree`.

## Features

- **Overlay** for NixOS: add the flake overlay and install `pkgs.nix-nvim`
- **devShell**: run `nix develop` to get a shell with the configured Neovim
- **Dendritic layout**: `flake.nixNvimModules.base`, `flake.nixNvimModules.plugin`, `flake.nixNvimModules.plugins.<name>` map to the `modules/nixNvim/` tree
- **Plugin modules**: LSP, Telescope, Treesitter (and more) as composable modules that aggregate into one config

## Requirements

- Nix with flakes enabled
- Inputs: `nixpkgs`, `flake-parts`, `import-tree` (declared in the flake)

## Quick start

### Run Neovim (from this repo)

```bash
nix run .#nix-nvim
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
          environment.systemPackages = [ pkgs.nix-nvim ];
        }
      ];
    };
  };
}
```

With the overlay applied, the package is available as `pkgs.nix-nvim`. Add it to `environment.systemPackages` in your NixOS config (e.g. `configuration.nix`) if not already set in the module above.

### devShell

```bash
nix develop
# then: nvim
```

## Project layout

```
.
├── flake.nix              # Flake entry; uses import-tree ./modules
├── overlay.nix             # Nixpkgs overlay (exposes nix-nvim)
├── README.md
└── modules/
    └── nixNvim/           # Dendritic path: flake.nixNvimModules.*
        ├── base.nix        # flake.nixNvimModules.base
        ├── options.nix     # options.flake.nixNvim, flake.nixNvimModules
        ├── package.nix     # Builds the derivation and devShell (perSystem)
        ├── plugin.nix      # flake.nixNvimModules.plugin (option template)
        ├── plugins-aggregate.nix  # Merges plugins.* into flake.nixNvim
        └── plugins/
            ├── lsp.nix     # flake.nixNvimModules.plugins.lsp
            ├── telescope.nix
            └── treesitter.nix
```

- **import-tree** imports every `.nix` under `modules/`; the directory structure under `modules/nixNvim/` mirrors the option path `flake.nixNvimModules.*`.
- **options.nix** defines `flake.nixNvim` (main config) and `flake.nixNvimModules` (module set).
- **package.nix** builds the Neovim derivation and devShell in `perSystem`, resolving `pluginNames` and `extraPackageNames` with `pkgs`.
- **plugins-aggregate.nix** concatenates all `flake.nixNvimModules.plugins.*` into `flake.nixNvim` (pluginNames, extraPackageNames, extraLua, extraVim).

## Configuration options

Under `config.flake.nixNvim` (or the option `flake.nixNvim`):

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | bool | `true` | Whether to build the package and devShell. |
| `packageName` | string | `"nix-nvim"` | Name of the package and app. |
| `plugins` | listOf package | `[]` | Plugin packages (can also be filled via `pluginNames`). |
| `pluginNames` | listOf string | `[]` | Vim plugin names (e.g. `nvim-lspconfig`) resolved with `pkgs.vimPlugins`. |
| `extraPackages` | listOf package | `[]` | Extra packages on PATH. |
| `extraPackageNames` | listOf string | `[]` | Extra package names (e.g. `lua-language-server`) resolved with `pkgs`. |
| `extraLua` | lines | `""` | Lua appended to the config. |
| `extraVim` | lines | `""` | Vimscript appended to the config. |
| `viAlias` / `vimAlias` | bool | `true` | Create `vi`/`vim` aliases. |
| `withNodeJs` / `withPython3` / `withRuby` | bool | varies | Provider support. |

Plugin modules (e.g. `plugins/lsp.nix`) set `flake.nixNvimModules.plugins.<name>` with `pluginNames`, `extraPackageNames`, `extraLua`, and `extraVim`; the aggregator merges them into the main `flake.nixNvim` config.

## Adding a plugin module

1. Create `modules/nixNvim/plugins/<name>.nix`.
2. Set `flake.nixNvimModules.plugins.<name>` and import the plugin template:

```nix
{ config, ... }:
{
  flake.nixNvimModules.plugins.<name> = {
    imports = [ config.flake.nixNvimModules.plugin ];
    pluginNames = [ "some-vim-plugin" ];
    extraPackageNames = [ ];  # optional
    extraLua = '' ... '';
    extraVim = '' ... '';      # optional
  };
}
```

3. No need to register the file; `import-tree` picks it up and the aggregator will include it.

## Flake outputs

- **packages.***system*.**nix-nvim** / **default** – Neovim derivation
- **apps.***system*.**nix-nvim** / **default** – Run Neovim
- **devShells.***system*.**default** – Shell with `nix-nvim` on PATH
- **overlays.default** – Nixpkgs overlay (use in NixOS as above)

## Why `nixNvimModules` instead of `flake.modules.nixNvim`?

`flake.modules` is reserved by flake-parts for the list of NixOS modules that configure the flake. To avoid a clash, this flake uses **flake.nixNvimModules** for the dendritic module tree (base, plugin, plugins.*). The main config remains **flake.nixNvim**.

## License

See repository or specify your license here.
