local Parent = script:FindFirstAncestor("CollectionViews").Parent
local ArgCheck = require(Parent.ArgCheck)

local function calculateSpacePerItem(n1: number, n2: number) -- line: 15
	-- upvalues: ArgCheck (copy)
	if n1 <= 1 then
		return {
			gapOffsetPerItem = 0,
			adjustedGap = n2
		}
	end

	ArgCheck.assert(n1 >= 2)

	local v6 = n1 - 1
	local v7 = math.floor(v6 / n1 * n2)
	local v8 = n2 + (v7 * n1 - n2 * v6) / v6

	return {
		gapOffsetPerItem = v7,
		adjustedGap = v8
	}
end

return calculateSpacePerItem
