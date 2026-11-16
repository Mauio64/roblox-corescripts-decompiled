require(script.Parent.types)
local function getCurrentNavigationState(p)
	if p.routes and p.index then
		return getCurrentNavigationState(p.routes[p.index])
	end

	return p
end

return getCurrentNavigationState
