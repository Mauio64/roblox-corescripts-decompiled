require(script.Parent.types)
local function getRouteKeyIsInNavigationState(p: string, route): boolean
	if route.key == p then
		return true
	end

	if route.routes then
		for _, route2 in pairs(route.routes) do
			if getRouteKeyIsInNavigationState(p, route2) then
				return true
			end
		end
	end

	return false
end

return getRouteKeyIsInNavigationState
