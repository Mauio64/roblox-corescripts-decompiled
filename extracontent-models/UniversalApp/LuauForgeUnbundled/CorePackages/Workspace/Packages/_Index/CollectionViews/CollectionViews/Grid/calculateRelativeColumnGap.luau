local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/ArgCheck")

local function calculateRelativeColumnGap(p2, p3, p4, p5)
	if p2 < 2 then
		return 0
	end

	ArgCheck.assert(p2 >= 2)

	local v5 = p2 * p4 + (p2 - 1) * p3 + 2 * p5

	if v5 > 0 then
		return p3 / v5
	end

	return 0
end

return calculateRelativeColumnGap
