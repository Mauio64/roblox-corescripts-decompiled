local Navigation = script:FindFirstAncestor("Navigation")
require(script.Parent.types)
local parent = Navigation.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
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
		joined = Array.concat(joined, getFocusedRoutes(route2))
	end

	return joined
end

return getFocusedRoutes
