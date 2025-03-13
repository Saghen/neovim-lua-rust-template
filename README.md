# Neovim Lua Rust Template

A template for creating Neovim plugins in Lua with an accompanying Rust library.

## Usage

1. Rename all instances of `your-plugin` to the name of your plugin
    - `name` in `Cargo.toml`
    - `lua/your-plugin` directory
    - `fn your_plugin_rust` in `lua/your-plugin/rust/lib.rs`
    - `require('your_plugin_rust')` in `lua/your-plugin/rust/init.lua`
    - All instances of `require('your-plugin...`
    - Types in `lua/your-plugin/config.lua`
    - Library name (in matrix) in `.github/workflows/release.yaml`
2. Build with `cargo build --release`
3. Install with your plugin manager of choice
    - For example, with lazy.nvim using `dev = { path = "~/path/to/parent/folder" }` (one level higher than this folder) and `{ 'username/your-plugin', dev = true }`
