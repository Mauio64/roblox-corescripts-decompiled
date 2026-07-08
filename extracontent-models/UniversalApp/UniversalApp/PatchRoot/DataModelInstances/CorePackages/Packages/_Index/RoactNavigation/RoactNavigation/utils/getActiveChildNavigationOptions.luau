return function(p1, p2) -- line: 4
	local state = p1.state
	local router = p1.router
	local v5 = p1.getChildNavigation(state.routes[state.index].key)

	return router.getScreenOptions(v5, p2)
end
