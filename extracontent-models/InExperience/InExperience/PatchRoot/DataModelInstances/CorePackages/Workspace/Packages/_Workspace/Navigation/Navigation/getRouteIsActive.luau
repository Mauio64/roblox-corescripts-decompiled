local Navigation = script:FindFirstAncestor("Navigation")
local parent = Navigation.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array

local getActiveRoutes = require(Navigation.getActiveRoutes)
require(script.Parent.types)

local function getRouteIsActive(p, p2: string): boolean
	return Array.find(getActiveRoutes(p), function(p3): boolean
		return p3.routeName == p2
	end) ~= nil
end

return getRouteIsActive
