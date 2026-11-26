require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/types")

local array = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/LuauPolyfill").Array
local function getFocusedRoutes(route)
	local joined = {}

	if route == nil then
		return joined
	end

	if route.key or route.routeName then
		table.insert(joined, route)
	end

	if route.routes and route.index ~= nil then
		local route2 = route.routes[route.index]
		joined = array.concat(joined, getFocusedRoutes(route2))
	end

	return joined
end

return getFocusedRoutes
