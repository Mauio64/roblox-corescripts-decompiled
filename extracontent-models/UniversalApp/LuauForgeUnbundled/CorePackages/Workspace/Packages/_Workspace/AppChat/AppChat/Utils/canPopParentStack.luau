local function canPopParentStack(p2): boolean
	if not (p2 and p2._dangerouslyGetParent) then
		return false
	end

	local dangerouslyGetParent = p2._dangerouslyGetParent()
	local state = dangerouslyGetParent and dangerouslyGetParent.state

	if state and state.routes then
		return #state.routes > 1
	end

	return false
end

return canPopParentStack
