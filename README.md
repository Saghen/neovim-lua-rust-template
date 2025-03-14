# Neovim Lua Rust Template

A template for creating Neovim plugins in Lua with an accompanying Rust library.

## Getting Started

Ensure you have [lazydev.nvim](https://github.com/folke/lazydev.nvim) installed if you're missing autocompletion in Lua files. Rename all instances of `your-plugin` to the name of your plugin.

```bash
mv lua/your-plugin lua/new-name

rg -l 'your-plugin' | xargs sed -i 's/your-plugin/new-name/g'
rg -l 'your_plugin' | xargs sed -i 's/your_plugin/new_name/g'

rg -l 'your-username' | xargs sed -i 's/your-username/new-username/g'
```

## Installation

### Development

```lua
{
  'your-username/your-plugin',

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
  'your-username/your-plugin',
  version = '*', -- only required with prebuilt binaries

  -- optional, see `lua/init.lua`
  -- download prebuilt binaries, from github releases, and setup `cpath`
  dependencies = 'saghen/blink.download',
  -- OR build from source
  build = 'cargo build --release',

  opts = {}
}
