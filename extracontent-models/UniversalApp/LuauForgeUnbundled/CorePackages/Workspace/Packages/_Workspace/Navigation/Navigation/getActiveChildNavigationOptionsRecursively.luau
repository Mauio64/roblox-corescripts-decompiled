require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/types")

return function(data, p2)
	local state = data.state
	local router = data.router
	local getChildNavigation = data.getChildNavigation

	local routes = state.routes
	local v5 = nil

	while routes do
		local childNavigation = getChildNavigation(routes[state.index].key)
		v5 = router.getScreenOptions(childNavigation, p2)

		if not childNavigation then
			break
		end

		getChildNavigation = childNavigation.getChildNavigation
		state = childNavigation.state
		routes = state.routes
		router = childNavigation.router
	end

	return v5
end
