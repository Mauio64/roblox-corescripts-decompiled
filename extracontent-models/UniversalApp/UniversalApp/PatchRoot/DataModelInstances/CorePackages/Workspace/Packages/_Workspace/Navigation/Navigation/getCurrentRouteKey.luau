require(script.Parent.types)

local getCurrentRouteState = require(script.Parent.getCurrentRouteState)

local function getCurrentRouteKey(p1) -- line: 7
	-- upvalues: getCurrentRouteState (copy)
	local v4 = getCurrentRouteState(p1)

	if v4 then
		return v4.key
	end

	return nil
end

return getCurrentRouteKey
