local module = require("@luauforge/deferred/hcS")

local module2 = require("@luauforge/deferred/hdf")
local module3 = require("@luauforge/deferred/hdg")

local function ResponsiveEdgeSurfaceContainer(p2)
	local v5 = module3(p2)
	return module.createElement(module2, v5)
end

return ResponsiveEdgeSurfaceContainer
