require(script.Parent.types)
local getCurrentRouteState = require(script.Parent.getCurrentRouteState)

local function getCurrentRouteKey(p)
	local currentRouteState = getCurrentRouteState(p)
	return if currentRouteState then currentRouteState.key else nil
end

return getCurrentRouteKey
