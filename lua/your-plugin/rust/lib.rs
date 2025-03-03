use mlua::prelude::*;

pub fn math(_lua: &Lua, (a, b): (i64, i64)) -> LuaResult<(i64, i64)> {
    Ok((a + b, a * b))
}

// If you're running into too much overhead from Lua <-> Rust
// explore skip_memory_check, which greatly improves performance
// https://github.com/mlua-rs/mlua/issues/318
// #[mlua::lua_module(skip_memory_check)]
#[mlua::lua_module]
fn your_plugin_rust(lua: &Lua) -> LuaResult<LuaTable> {
    let exports = lua.create_table()?;
    exports.set("math", lua.create_function(math)?)?;
    Ok(exports)
}
