require(script.Parent.types)

return function(data, p)
	local state = data.state
	local router = data.router
	local getChildNavigation = data.getChildNavigation

	local routes = state.routes
	local v = nil

	while routes do
		local childNavigation = getChildNavigation(routes[state.index].key)
		v = router.getScreenOptions(childNavigation, p)

		if not childNavigation then
			break
		end

		getChildNavigation = childNavigation.getChildNavigation
		state = childNavigation.state
		routes = state.routes
		router = childNavigation.router
	end

	return v
end
