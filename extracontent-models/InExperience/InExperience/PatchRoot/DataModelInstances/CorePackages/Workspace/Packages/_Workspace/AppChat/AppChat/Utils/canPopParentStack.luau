local function canPopParentStack(p): boolean
	if not (p and p._dangerouslyGetParent) then
		return false
	end

	local dangerouslyGetParent = p._dangerouslyGetParent()
	local state = dangerouslyGetParent and dangerouslyGetParent.state

	if state and state.routes then
		return #state.routes > 1
	end

	return false
end

return canPopParentStack
