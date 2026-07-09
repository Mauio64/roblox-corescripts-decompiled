local function isRootRoute(p1) -- line: 5
	-- upvalues: isRootRoute (copy)
	if p1.routes and #p1.routes > 1 then
		return false
	end

	local index = p1.index
	local v4 = p1.routes and p1.routes[index]

	if v4 then
		return isRootRoute(v4)
	end

	return true
end

return isRootRoute
