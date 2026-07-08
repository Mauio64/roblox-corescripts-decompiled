return function(p1) -- line: 3
	if not p1 then
		return {}
	end

	if not p1._childrenNavigation then
		p1._childrenNavigation = {}
	end

	local _childrenNavigation = p1._childrenNavigation
	local t1 = {}

	for _, v5 in p1.state.routes or {} do
		t1[v5.key] = true
	end

	if not p1.state.isTransitioning then
		for v6, _ in _childrenNavigation do
			if not t1[v6] then
				_childrenNavigation[v6] = nil
			end
		end
	end

	return p1._childrenNavigation
end
