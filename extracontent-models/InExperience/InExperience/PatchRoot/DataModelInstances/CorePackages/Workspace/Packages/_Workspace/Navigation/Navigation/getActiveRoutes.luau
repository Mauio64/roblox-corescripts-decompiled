local Navigation = script:FindFirstAncestor("Navigation")

require(script.Parent.types)

local NavigationParent = Navigation.Parent
local Array = require(NavigationParent.LuauPolyfill).Array

local function isStackRoute(p1) -- line: 15
	return p1.index ~= nil and (p1.routes ~= nil and p1.isTransitioning ~= nil)
end
local function getActiveRoutes(p2) -- line: 29
	-- upvalues: Array (copy), getActiveRoutes (copy)
	local t1 = {}

	if p2 == nil then
		return t1
	end

	if p2.key or p2.routeName then
		table.insert(t1, p2)
	end

	if p2.routes and p2.index ~= nil then
		local routes = p2.routes
		local index = p2.index

		if p2.index ~= nil and (p2.routes ~= nil and p2.isTransitioning ~= nil) then
			for i = 1, index - 1 do
				local v12 = routes[i]

				t1 = Array.concat(t1, getActiveRoutes(v12))
			end
		end

		local v13 = routes[index]

		t1 = Array.concat(t1, getActiveRoutes(v13))
	end

	return t1
end

return getActiveRoutes
