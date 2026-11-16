require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Navigation")

local function getGameDetailsNavigation(p2)
	if typeof(p2.clearAppScreens) == "function" then
		return p2
	end

	local clone = table.clone(p2)
	function clone.clearAppScreens(p3)
		p2.dispatch({ type = "ClearAppScreensAction", routeNames = p3 })
	end

	return clone
end

return getGameDetailsNavigation
