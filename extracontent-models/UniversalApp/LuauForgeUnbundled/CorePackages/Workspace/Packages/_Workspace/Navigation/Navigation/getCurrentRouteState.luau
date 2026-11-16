require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/types")
local getCurrentNavigationState = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/getCurrentNavigationState")

local function getCurrentRouteState(p2)
	if not p2 then
		return nil
	end

	if p2.state then
		return getCurrentNavigationState(p2.state)
	end

	return nil
end

return getCurrentRouteState
