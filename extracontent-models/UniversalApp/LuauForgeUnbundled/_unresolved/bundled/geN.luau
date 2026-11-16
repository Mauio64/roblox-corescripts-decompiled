local function dumpNavigationRoute(p2, p3)
	local v5 = ""
	local v6 = p3 .. "   "
	local index = p2.index

	if p2 and p2.routes then
		for k, route in p2.routes do
			local v7 = route.routeName

			if k == index then
				v7 = "*" .. v7
			end

			v5 = (v5 .. v6 .. v7 .. "\n") .. dumpNavigationRoute(route, v6)
		end
	end

	return v5
end

return function(p2)
	return "[Navigation Root]\n" .. dumpNavigationRoute(p2, "")
end
