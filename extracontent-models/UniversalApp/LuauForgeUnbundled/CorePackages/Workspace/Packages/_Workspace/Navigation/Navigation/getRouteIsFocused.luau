local array = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/LuauPolyfill").Array

local getFocusedRoutes = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/getFocusedRoutes")
require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/types")

local function getRouteIsFocused(p2, p3): boolean
	return array.find(getFocusedRoutes(p2), function(p4): boolean
		return p4.routeName == p3
	end) ~= nil
end

return getRouteIsFocused
