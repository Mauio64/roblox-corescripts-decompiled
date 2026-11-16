local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/ArgCheck")

local function calculateNumColumns(p2, p3, p4, p5, p6, p7)
	ArgCheck.assert(p2 >= 1)
	ArgCheck.assert(p3 >= 0)
	local v5 = math.floor((p6 + p3) / (p2 + p3))

	if p7 then
		v5 = math.floor(v5 * 0.5) * 2
	end

	return (math.min(p5, (math.max(p4, v5))))
end

return calculateNumColumns
