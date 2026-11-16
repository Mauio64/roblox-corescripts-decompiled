local getCurrentRouteKey = require(script.Parent.getCurrentRouteKey)
local useNavigation = require(script.Parent.useNavigation)

local function useCurrentRouteKey()
	return getCurrentRouteKey((useNavigation()))
end

return useCurrentRouteKey
