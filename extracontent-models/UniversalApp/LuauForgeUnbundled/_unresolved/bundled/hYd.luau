local module = require("@luauforge/bundled/hYe")
local module2 = require("@luauforge/bundled/hYf")
local module3 = require("@luauforge/bundled/hHb")

local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging

local v5 = { ["dark"] = module3, light = module2, classic = module }

return function(value)
	if value == nil or not (#value > 0) then
		return module
	end

	local v6 = v5[string.lower(value)]

	if v6 ~= nil then
		return v6
	end

	logging.warn("Unrecognized theme name: " .. value)

	return module
end
