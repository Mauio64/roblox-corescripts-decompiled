require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/types")
local function getCurrentNavigationState(p2)
	if p2.routes and p2.index then
		return getCurrentNavigationState(p2.routes[p2.index])
	end

	return p2
end

return getCurrentNavigationState
