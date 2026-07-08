local Parent = script:FindFirstAncestor("CollectionViews").Parent
local ArgCheck = require(Parent.ArgCheck)

local function calculateNumColumns(n1: number, n2: number, n3: number, n4: number, n5: number, b1: boolean?) -- line: 9
	-- upvalues: ArgCheck (copy)
	ArgCheck.assert(n1 >= 1)
	ArgCheck.assert(n2 >= 0)

	local v10 = math.floor((n5 + n2) / (n1 + n2))

	if b1 then
		v10 = math.floor(v10 * 0.5) * 2
	end

	return (math.min(n4, (math.max(n3, v10))))
end

return calculateNumColumns
