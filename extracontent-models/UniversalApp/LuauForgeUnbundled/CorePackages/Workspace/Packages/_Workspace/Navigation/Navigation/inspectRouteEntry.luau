require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/types")

local __DEV__ = _G.__DEV__

local function inspectRouteEntry(items)
	local v5, v6 = next(items)

	if __DEV__ then
		assert(v5 and v6, "route entry should contain exactly one route config")
	end

	return v5, v6
end

return inspectRouteEntry
