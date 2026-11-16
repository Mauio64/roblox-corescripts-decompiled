local parent = script:FindFirstAncestor("BuildExperience").Parent

require(parent.Navigation)

local function getGameDetailsNavigation(p)
	if typeof(p.clearAppScreens) == "function" then
		return p
	end

	local clone = table.clone(p)
	function clone.clearAppScreens(routeNames)
		p.dispatch({ type = "ClearAppScreensAction", routeNames = routeNames })
	end

	return clone
end

return getGameDetailsNavigation
