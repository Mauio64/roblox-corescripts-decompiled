local array = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/LuauPolyfill").Array

local getActiveRoutes = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/getActiveRoutes")
require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/types")

local function getRouteIsActive(p2, p3): boolean
	return array.find(getActiveRoutes(p2), function(p4): boolean
		return p4.routeName == p3
	end) ~= nil
end

return getRouteIsActive
