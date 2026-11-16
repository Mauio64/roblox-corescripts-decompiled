require(script.Parent.types)
local getCurrentNavigationState = require(script.Parent.getCurrentNavigationState)

local function getCurrentRouteState(p)
	if not p then
		return nil
	end

	if p.state then
		return (getCurrentNavigationState(p.state))
	end

	return nil
end

return getCurrentRouteState
