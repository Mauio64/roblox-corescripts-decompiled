local Navigation = script:FindFirstAncestor("Navigation")
local NavigationParent = Navigation.Parent
local Array = require(NavigationParent.LuauPolyfill).Array
local getFocusedRoutes = require(Navigation.getFocusedRoutes)

require(script.Parent.types)

local function getRouteIsFocused(p1, s1: string) -- line: 12
	-- upvalues: Array (copy), getFocusedRoutes (copy)
	return Array.find(getFocusedRoutes(p1), function(p2) -- line: 13
		-- upvalues: s1 (copy)
		return p2.routeName == s1
	end) ~= nil
end

return getRouteIsFocused
