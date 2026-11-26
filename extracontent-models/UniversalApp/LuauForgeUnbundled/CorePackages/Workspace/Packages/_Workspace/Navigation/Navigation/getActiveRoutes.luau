require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/types")

local array = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/LuauPolyfill").Array

local function isStackRoute(data): boolean
	return data.index ~= nil and data.routes ~= nil and data.isTransitioning ~= nil
end

local function getActiveRoutes(route)
	local joined = {}

	if route == nil then
		return joined
	end

	if route.key or route.routeName then
		table.insert(joined, route)
	end

	if not route.routes or route.index == nil then
		return joined
	end

	local routes = route.routes
	local index = route.index
	local v5 = not (route.index == nil or route.routes == nil) and route.isTransitioning ~= nil

	if v5 then
		for i = 1, index - 1 do
			local route2 = routes[i]
			joined = array.concat(joined, getActiveRoutes(route2))
		end
	end

	local route2 = routes[index]
	joined = array.concat(joined, getActiveRoutes(route2))

	return joined
end

return getActiveRoutes
