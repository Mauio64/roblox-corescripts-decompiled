require(script.Parent.types)

local getCurrentNavigationState = require(script.Parent.getCurrentNavigationState)

local function getCurrentRouteState(p1) -- line: 8
	-- upvalues: getCurrentNavigationState (copy)
	if not p1 then
		return nil
	end

	if not p1.state then
		return nil
	end

	return (getCurrentNavigationState(p1.state))
end

return getCurrentRouteState
