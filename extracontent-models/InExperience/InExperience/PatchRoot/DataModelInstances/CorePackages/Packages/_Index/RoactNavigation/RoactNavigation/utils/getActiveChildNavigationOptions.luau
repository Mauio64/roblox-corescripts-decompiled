return function(data, p)
	local state = data.state
	local router = data.router
	local childNavigation = data.getChildNavigation(state.routes[state.index].key)

	return router.getScreenOptions(childNavigation, p)
end
