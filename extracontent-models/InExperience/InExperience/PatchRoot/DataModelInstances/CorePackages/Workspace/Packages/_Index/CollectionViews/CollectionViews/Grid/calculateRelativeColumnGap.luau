local parent = script:FindFirstAncestor("CollectionViews").Parent
local ArgCheck = require(parent.ArgCheck)

local function calculateRelativeColumnGap(p: number, p2: number, p3: number, p4: number)
	if p < 2 then
		return 0
	end

	ArgCheck.assert(p >= 2)

	local v = p * p3 + (p - 1) * p2 + p4 * 2

	if v > 0 then
		return p2 / v
	end

	return 0
end

return calculateRelativeColumnGap
