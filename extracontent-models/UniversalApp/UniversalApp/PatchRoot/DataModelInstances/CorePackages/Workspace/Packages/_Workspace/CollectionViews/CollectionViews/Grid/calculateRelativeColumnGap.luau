local Parent = script:FindFirstAncestor("CollectionViews").Parent
local ArgCheck = require(Parent.ArgCheck)

local function calculateRelativeColumnGap(n1: number, n2: number, n3: number, n4: number) -- line: 8
	-- upvalues: ArgCheck (copy)
	if n1 < 2 then
		return 0
	end

	ArgCheck.assert(n1 >= 2)

	local v8 = n1 * n3 + (n1 - 1) * n2 + n4 * 2

	if v8 > 0 then
		return n2 / v8
	end

	return 0
end

return calculateRelativeColumnGap
