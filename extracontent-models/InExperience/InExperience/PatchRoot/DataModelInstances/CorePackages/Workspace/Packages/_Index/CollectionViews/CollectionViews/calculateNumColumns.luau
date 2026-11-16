local parent = script:FindFirstAncestor("CollectionViews").Parent
local ArgCheck = require(parent.ArgCheck)

local function calculateNumColumns(p: number, p2: number, p3: number, p4: number, p5: number, flag: boolean?)
	ArgCheck.assert(p >= 1)
	ArgCheck.assert(p2 >= 0)
	local v = math.floor((p5 + p2) / (p + p2))

	if flag then
		v = math.floor(v * 0.5) * 2
	end

	return (math.min(p4, (math.max(p3, v))))
end

return calculateNumColumns
