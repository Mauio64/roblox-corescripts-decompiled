require(script.Parent.types)

return function(p1, p2) -- line: 6
	local state = p1.state
	local router = p1.router
	local getChildNavigation = p1.getChildNavigation
	local routes = state.routes
	local v7 = nil

	while routes do
		local v8 = getChildNavigation(routes[state.index].key)

		v7 = router.getScreenOptions(v8, p2)

		if not v8 then
			return v7
		end

		getChildNavigation = v8.getChildNavigation
		state = v8.state
		routes = state.routes
		router = v8.router
	end

	return v7
end
