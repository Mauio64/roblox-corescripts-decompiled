require(script.Parent.types)

local __DEV__ = _G.__DEV__

local function inspectRouteEntry(items)
	local v, v2 = next(items)

	if __DEV__ then
		assert(v and v2, "route entry should contain exactly one route config")
	end

	return v, v2
end

return inspectRouteEntry
