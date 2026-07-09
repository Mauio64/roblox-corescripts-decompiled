local Navigation = script:FindFirstAncestor("Navigation")
local NavigationParent = Navigation.Parent
local Array = require(NavigationParent.LuauPolyfill).Array
local getActiveRoutes = require(Navigation.getActiveRoutes)

require(script.Parent.types)

local function getRouteIsActive(p1, s1: string) -- line: 12
	-- upvalues: Array (copy), getActiveRoutes (copy)
	return Array.find(getActiveRoutes(p1), function(p2) -- line: 13
		-- upvalues: s1 (copy)
		return p2.routeName == s1
	end) ~= nil
end

return getRouteIsActive
