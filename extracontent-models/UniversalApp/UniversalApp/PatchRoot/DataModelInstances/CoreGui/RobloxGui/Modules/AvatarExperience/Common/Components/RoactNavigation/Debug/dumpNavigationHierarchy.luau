local function dumpNavigationRoute(t1: {[any]: any}, s1: string) -- line: 15
	-- upvalues: dumpNavigationRoute (copy)
	local s2 = ""
	local v5 = s1 .. "   "
	local index = t1.index

	if t1 and t1.routes then
		for v7, v8 in t1.routes do
			local routeName = v8.routeName

			if v7 == index then
				routeName = "*" .. routeName
			end

			s2 = (s2 .. v5 .. routeName .. "\n") .. dumpNavigationRoute(v8, v5)
		end
	end

	return s2
end

return function(p1) -- line: 32
	-- upvalues: dumpNavigationRoute (copy)
	return "[Navigation Root]\n" .. dumpNavigationRoute(p1, "")
end
