local function isRootRoute(p2)
	if p2.routes and #p2.routes > 1 then
		return false
	end

	local index = p2.index
	local v5 = p2.routes and p2.routes[index]

	if v5 then
		return isRootRoute(v5)
	end

	return true
end

return isRootRoute
