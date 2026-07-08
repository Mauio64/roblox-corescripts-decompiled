require(script.Parent.types)

local __DEV__ = _G.__DEV__

local function inspectRouteEntry(p1) -- line: 5
	-- upvalues: __DEV__ (copy)
	local v4, v5 = next(p1)

	if __DEV__ then
		assert(v4 and v5, "route entry should contain exactly one route config")
	end

	return v4, v5
end

return inspectRouteEntry
