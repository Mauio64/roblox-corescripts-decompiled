local parent = script:FindFirstAncestor("CollectionViews").Parent
local ArgCheck = require(parent.ArgCheck)

local function calculateItemWidth(p: number, p2: number, p3: number, p4: number, p5: number, value: number?)
	if p <= 0 then
		return 0
	end

	ArgCheck.assert(p >= 1)

	local v = p2 * (p - 1)
	return (math.max(1, (p4 - (p3 * 2 + (value or 0)) - v) / (p + p5)))
end

return calculateItemWidth
