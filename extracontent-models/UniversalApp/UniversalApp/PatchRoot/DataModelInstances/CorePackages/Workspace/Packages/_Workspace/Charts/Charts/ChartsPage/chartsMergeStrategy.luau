local Parent = script:FindFirstAncestor("Charts").Parent
local FFlagSduiChartsRequestPlaceholders = require(Parent.SharedFlags).FFlagSduiChartsRequestPlaceholders

require(Parent.SduiSharedUtilities)

local function hasAnyOverlap(t1: {[any]: any}?, t2: {[any]: any}) -- line: 10
	if t1 == nil or #t1 == 0 then
		return false
	end

	local t3 = {}

	for _, v9 in t1 do
		t3[v9] = true
	end

	for _, v11 in t2 do
		if t3[v11] then
			return true
		end
	end

	return false
end
local function chartsMergeStrategy(t4: {[any]: any}, p1, p2) -- line: 41
	-- upvalues: FFlagSduiChartsRequestPlaceholders (copy), hasAnyOverlap (copy)
	if FFlagSduiChartsRequestPlaceholders and (#t4 == 1 and t4[1] == "entry_order") then
		if hasAnyOverlap(p2, p1) then
			return "replace"
		end

		return "append"
	end

	return nil
end

return chartsMergeStrategy
