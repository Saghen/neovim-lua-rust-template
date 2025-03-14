local plugin = {}

--- @param opts your-plugin.Config
function plugin.setup(opts)
  local config = require('your-plugin.config')
  config.merge_with(opts)

  plugin.download_if_available(function(err)
    if err then error(err) end

    local rust_module = require('your-plugin.rust')
    vim.api.nvim_create_user_command('Math', function(args)
      local a = args.fargs[1]
      local b = args.fargs[2]
      local add, multi = rust_module.math(a, b)

      print('Added: ' .. add)
      print('Multiplied: ' .. multi)
    end, { nargs = '+' })
  end)
end

--- You may optionally use `blink.download` for prebuilt binaries with the included `Cross.toml`
--- and `.github/workflows/release.yaml`
function plugin.download_if_available(callback)
  local success, downloader = pcall(require, 'blink.download')
  if not success then return callback() end

  -- See https://github.com/Saghen/blink.download for more info
  local root_dir = vim.fn.resolve(debug.getinfo(1).source:match('@?(.*/)') .. '../../')

  downloader.ensure_downloaded({
    -- omit this property to disable downloading
    -- i.e. https://github.com/Saghen/blink.delimiters/releases/download/v0.1.0/x86_64-unknown-linux-gnu.so
    download_url = function(version, system_triple, extension)
      return 'https://github.com/your-username/your-plugin/releases/download/'
        .. version
        .. '/'
        .. system_triple
        .. extension
    end,
    on_download = function()
      vim.notify('[your-plugin] Downloading prebuilt binary...', vim.log.levels.INFO, { title = 'your-plugin' })
    end,

    root_dir,
    output_dir = '/target/release',
    binary_name = 'your_plugin', -- excluding `lib` prefix
  }, callback)
end

return plugin
