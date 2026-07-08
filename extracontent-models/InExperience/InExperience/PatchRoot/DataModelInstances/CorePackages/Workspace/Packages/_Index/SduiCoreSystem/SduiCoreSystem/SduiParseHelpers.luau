local Parent = script:FindFirstAncestor("SduiCoreSystem").Parent
local tutils = require(Parent.tutils)

local function hasCycle(t1: {[any]: any}, t2: {[any]: any}?) -- line: 5
	-- upvalues: hasCycle (copy)
	if t2 == nil then
		t2 = {}
	end

	assert(t2, "seenNodes must exist")

	for _, v7 in t1 do
		if typeof(v7) ~= "table" then
			continue
		end

		if t2[v7] then
			return true
		end

		t2[v7] = true

		if hasCycle(v7, t2) then
			return true
		end
	end

	return false
end

return {
	hasCycle = hasCycle,
	stringifyValue = function(p1) -- line: 26
		-- upvalues: hasCycle (copy), tutils (copy)
		if typeof(p1) == "table" then
			if hasCycle(p1) then
				return "table-with-cycle"
			end

			return tutils.toString(p1)
		end

		return tutils.toString(p1)
	end
}
