local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging

logging.warn("Lua App Bootcamp Enabled")

local module = require("@luauforge/bundled/ieG")
return {
	runBootcamp = function(p2)
		for i, v6 in ipairs(module) do
			logging.warn(v6)
		end
	end
}
