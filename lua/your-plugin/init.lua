local plugin = {}

--- @param opts your-plugin.Config
function plugin.setup(opts)
	local config = require("your-plugin.config")
	config.merge_with(opts)

	vim.api.nvim_create_user_command("Math", function(args)
		local a = args.fargs[1]
		local b = args.fargs[2]
		local add, multi = require("your-plugin.rust").math(a, b)

		print("Added: " .. add)
		print("Multiplied: " .. multi)
	end, { nargs = "+" })
end

return plugin
