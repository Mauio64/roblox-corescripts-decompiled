local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/tutils")
local function hasCycle(items, p2): boolean
	local v5 = p2 == nil and {} or p2

	assert(v5, "seenNodes must exist")

	for k, item in items do
		if typeof(item) ~= "table" then
			continue
		end

		if v5[item] then
			return true
		end

		v5[item] = true

		if hasCycle(item, v5) then
			return true
		end
	end

	return false
end

return {
	hasCycle = hasCycle,
	stringifyValue = function(p2)
		if typeof(p2) ~= "table" then
			return tutils.toString(p2)
		end

		if hasCycle(p2) then
			return "table-with-cycle"
		end

		return tutils.toString(p2)
	end
}
