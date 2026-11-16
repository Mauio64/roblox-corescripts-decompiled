return function(state)
	if not state then
		return {}
	end

	if not state._childrenNavigation then
		state._childrenNavigation = {}
	end

	local childrenNavigation = state._childrenNavigation

	local set = {}

	for _, v in state.state.routes or {} do
		set[v.key] = true
	end

	if not state.state.isTransitioning then
		for k, _ in childrenNavigation do
			if not set[k] then
				childrenNavigation[k] = nil
			end
		end
	end

	return state._childrenNavigation
end
