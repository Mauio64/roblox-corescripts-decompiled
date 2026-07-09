local Navigation = script:FindFirstAncestor("Navigation")

require(script.Parent.types)

local NavigationParent = Navigation.Parent
local Array = require(NavigationParent.LuauPolyfill).Array

local function getFocusedRoutes(p1) -- line: 10
	-- upvalues: Array (copy), getFocusedRoutes (copy)
	local t1 = {}

	if p1 == nil then
		return t1
	end

	if p1.key or p1.routeName then
		table.insert(t1, p1)
	end

	if p1.routes and p1.index ~= nil then
		local v7 = p1.routes[p1.index]

		t1 = Array.concat(t1, getFocusedRoutes(v7))
	end

	return t1
end

return getFocusedRoutes
