local Navigation = script:FindFirstAncestor("Navigation")
require(script.Parent.types)
local parent = Navigation.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array

local function isStackRoute(data): boolean -- 1 equivalent call inferred from this helper
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

	if isStackRoute(route) then -- inferred equivalent call
		for i = 1, index - 1 do
			local route2 = routes[i]
			joined = Array.concat(joined, getActiveRoutes(route2))
		end
	end

	local route2 = routes[index]
	joined = Array.concat(joined, getActiveRoutes(route2))

	return joined
end

return getActiveRoutes
