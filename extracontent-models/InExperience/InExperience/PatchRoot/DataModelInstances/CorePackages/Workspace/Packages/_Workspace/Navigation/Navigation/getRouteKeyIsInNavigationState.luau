require(script.Parent.types)

local function getRouteKeyIsInNavigationState(s1: string, p1) -- line: 6
	-- upvalues: getRouteKeyIsInNavigationState (copy)
	if s1 == p1.key then
		return true
	end

	if p1.routes then
		for _, v in pairs(p1.routes) do
			if getRouteKeyIsInNavigationState(s1, v) then
				return true
			end
		end
	end

	return false
end

return getRouteKeyIsInNavigationState
