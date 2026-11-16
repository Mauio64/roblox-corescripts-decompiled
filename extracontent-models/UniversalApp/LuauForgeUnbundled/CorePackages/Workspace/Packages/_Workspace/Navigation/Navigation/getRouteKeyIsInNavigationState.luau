require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/types")
local function getRouteKeyIsInNavigationState(p2, route): boolean
	if route.key == p2 then
		return true
	end

	if route.routes then
		for k, route2 in pairs(route.routes) do
			if getRouteKeyIsInNavigationState(p2, route2) then
				return true
			end
		end
	end

	return false
end

return getRouteKeyIsInNavigationState
