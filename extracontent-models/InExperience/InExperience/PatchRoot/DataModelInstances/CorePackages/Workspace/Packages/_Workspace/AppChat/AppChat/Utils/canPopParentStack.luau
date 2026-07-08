local function canPopParentStack(p1) -- line: 6
	if not p1 or not p1._dangerouslyGetParent then
		return false
	end

	local v3 = p1._dangerouslyGetParent()
	local v4 = v3 and v3.state

	if not v4 or not v4.routes then
		return false
	end

	return #v4.routes > 1
end

return canPopParentStack
