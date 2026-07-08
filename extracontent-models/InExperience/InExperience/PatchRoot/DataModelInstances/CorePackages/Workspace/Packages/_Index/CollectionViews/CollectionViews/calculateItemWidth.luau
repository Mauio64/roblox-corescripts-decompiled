local Parent = script:FindFirstAncestor("CollectionViews").Parent
local ArgCheck = require(Parent.ArgCheck)

local function calculateItemWidth(n1: number, n2: number, n3: number, n4: number, n5: number, n6: number?) -- line: 8
	-- upvalues: ArgCheck (copy)
	if n1 <= 0 then
		return 0
	end

	ArgCheck.assert(n1 >= 1)

	local v10 = n2 * (n1 - 1)

	return (math.max(1, (n4 - (n3 * 2 + (n6 or 0)) - v10) / (n1 + n5)))
end

return calculateItemWidth
