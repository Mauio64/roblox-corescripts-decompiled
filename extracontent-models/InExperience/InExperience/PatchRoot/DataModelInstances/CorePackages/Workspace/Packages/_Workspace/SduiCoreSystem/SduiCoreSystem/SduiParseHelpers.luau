local parent = script:FindFirstAncestor("SduiCoreSystem").Parent
local tutils = require(parent.tutils)
local function hasCycle(items, p): boolean
	local v = p == nil and {} or p

	assert(v, "seenNodes must exist")

	for _, item in items do
		if typeof(item) ~= "table" then
			continue
		end

		if v[item] then
			return true
		end

		v[item] = true

		if hasCycle(item, v) then
			return true
		end
	end

	return false
end

return {
	hasCycle = hasCycle,
	stringifyValue = function(p)
		if typeof(p) ~= "table" then
			return tutils.toString(p)
		end

		if hasCycle(p) then
			return "table-with-cycle"
		end

		return tutils.toString(p)
	end
}
