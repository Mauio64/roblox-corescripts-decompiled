require(script.Parent.types)

local function getRootNavigation(p1) -- line: 4
	-- upvalues: getRootNavigation (copy)
	local v3 = p1._dangerouslyGetParent()

	if v3 then
		return (getRootNavigation(v3))
	end

	return p1
end

return getRootNavigation
