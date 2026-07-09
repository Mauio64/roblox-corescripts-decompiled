local getCurrentRouteKey = require(script.Parent.getCurrentRouteKey)
local useNavigation = require(script.Parent.useNavigation)

local function useCurrentRouteKey() -- line: 4
	-- upvalues: useNavigation (copy), getCurrentRouteKey (copy)
	local v4 = useNavigation()

	return getCurrentRouteKey(v4)
end

return useCurrentRouteKey
