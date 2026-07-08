require(script.Parent.types)

local function getCurrentNavigationState(p1) -- line: 7
	-- upvalues: getCurrentNavigationState (copy)
	if p1.routes and p1.index then
		return getCurrentNavigationState(p1.routes[p1.index])
	end

	return p1
end

return getCurrentNavigationState
