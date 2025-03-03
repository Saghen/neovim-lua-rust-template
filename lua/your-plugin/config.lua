--- Create a separate ConfigStrict which requires all fields to be set, for internal use
--- and a Config which marks all fields as optional, for use by the user like:
--- --- @module 'your-plugin'
--- --- @type your-plugin.Config

--- @class your-plugin.ConfigStrict
--- @field foo string
--- @field bar number

--- @class your-plugin.Config : your-plugin.ConfigStrict, {}

--- @type your-plugin.ConfigStrict
local config = {
	foo = "baz",
	bar = 0,
}

--- @type your-plugin.ConfigStrict
--- @diagnostic disable-next-line: missing-fields
local M = {}

--- @param config your-plugin.ConfigStrict
function M.validate(config)
	-- use vim.validate to validate the config
end

--- @param user_config your-plugin.Config
function M.merge_with(user_config)
	config = vim.tbl_deep_extend("force", config, user_config)
	M.validate(config)
end

return setmetatable(M, {
	__index = function(_, k)
		return config[k]
	end,
})
