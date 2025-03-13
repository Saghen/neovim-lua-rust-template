local plugin = {}

--- @param opts your-plugin.Config
function plugin.setup(opts)
  local config = require('your-plugin.config')
  config.merge_with(opts)

  -- You may optionally use `blink.download` for prebuilt binaries with the included `Cross.toml`
  -- and `.github/workflows/release.yaml`

  require('blink.download').ensure_downloaded({
    -- omit this property to disable downloading
    -- i.e. https://github.com/Saghen/blink.delimiters/releases/download/v0.1.0/x86_64-unknown-linux-gnu.so
    download_url = function(version, system_triple, extension)
      return 'https://github.com/username/your-plugin/releases/download/'
        .. version
        .. '/'
        .. system_triple
        .. extension
    end,

    module_name = 'your-plugin',
    -- optional, defaults to module_name with `.` and `-` replaced with `_`
    -- binary_name = 'your_plugin',
  }, function(err, module)
    if err then error(err) end

    plugin.finish_setup(module)

    -- optionally, load the module directly elsewhere in your plugin
    local module = require('your_plugin')
    -- or use the download.load function, to ensure cpath has been set
    local module = require('blink.download').load('your-plugin') -- optionally provide the binary_name too
  end)

  -- OR
  -- you may require users to build your plugin with `build = 'cargo build --release'` (lazy.nvim)
  -- and setup the `cpath` manually (see `lua/your-plugin/rust/init.lua`)

  -- plugin.finish_setup(require('your-plugin.rust'))
end

function plugin.finish_setup(rust_module)
  vim.api.nvim_create_user_command('Math', function(args)
    local a = args.fargs[1]
    local b = args.fargs[2]
    local add, multi = rust_module.math(a, b)

    print('Added: ' .. add)
    print('Multiplied: ' .. multi)
  end, { nargs = '+' })
end

return plugin
