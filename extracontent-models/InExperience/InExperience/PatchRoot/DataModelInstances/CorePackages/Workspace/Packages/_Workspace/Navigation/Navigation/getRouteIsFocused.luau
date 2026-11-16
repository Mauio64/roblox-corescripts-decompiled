local Navigation = script:FindFirstAncestor("Navigation")
local parent = Navigation.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array

local getFocusedRoutes = require(Navigation.getFocusedRoutes)
require(script.Parent.types)

local function getRouteIsFocused(p, p2: string): boolean
	return Array.find(getFocusedRoutes(p), function(p3): boolean
		return p3.routeName == p2
	end) ~= nil
end

return getRouteIsFocused
