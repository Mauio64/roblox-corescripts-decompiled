local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/ArgCheck")

local function calculateItemWidth(p2, p3, p4, p5, p6, value)
	if p2 <= 0 then
		return 0
	end

	ArgCheck.assert(p2 >= 1)

	local v5 = p3 * (p2 - 1)
	return (math.max(1, (p5 - (2 * p4 + (value or 0)) - v5) / (p2 + p6)))
end

return calculateItemWidth
