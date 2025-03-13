# Neovim Lua Rust Template

A template for creating Neovim plugins in Lua with an accompanying Rust library.

## Getting Started

Ensure you have [lazydev.nvim](https://github.com/folke/lazydev.nvim) installed if you're missing autocompletion in Lua files. Rename all instances of `your-plugin` to the name of your plugin.

- `name` in `Cargo.toml`
- `lua/your-plugin` directory
- `fn your_plugin` in `lua/your-plugin/rust/lib.rs`
- `require('your_plugin')` in `lua/your-plugin/rust/init.lua`
- All instances of `require('your-plugin...`
- Types in `lua/your-plugin/config.lua`
- Library name (in matrix) in `.github/workflows/release.yaml`

## Installation

### Development

```lua
{
  'username/your-plugin',

  -- see lazy.nvim docs (`config.dev`): https://lazy.folke.io/configuration
  dev = true,

  -- optional, see `lua/init.lua`
  dependencies = 'saghen/blink.download',

  build = 'cargo build --release',
  opts = {}
}
```

### Stable

```lua
{
  'username/your-plugin',
  version = '*', -- only required with prebuilt binaries

  -- optional, see `lua/init.lua`
  -- download prebuilt binaries, from github releases, and setup `cpath`
  dependencies = 'saghen/blink.download',
  -- OR build from source
  build = 'cargo build --release',

  opts = {}
}
