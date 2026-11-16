require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/types")
local getCurrentRouteState = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/getCurrentRouteState")

local function getCurrentRouteKey(p2)
	local v5 = getCurrentRouteState(p2)

	if v5 then
		return v5.key
	end

	return nil
end

return getCurrentRouteKey
