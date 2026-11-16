return function(state, p)
	if not state.SliceCenter then
		return state
	end

	local v = state.SliceCenter.Min * p
	local v2 = state.SliceCenter.Max * p
	state.SliceCenter = Rect.new(v, v2)
	state.SliceScale = (state.SliceScale or 1) / p

	return state
end
