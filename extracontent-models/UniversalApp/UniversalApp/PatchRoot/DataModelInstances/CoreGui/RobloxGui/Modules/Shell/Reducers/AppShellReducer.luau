game:GetService("CorePackages")

local scriptParent = script.Parent
local ScreenList = require(scriptParent.ScreenList)

return function(p1, p2) -- line: 8
	-- upvalues: ScreenList (copy)
	local v5 = p1 or {}

	return {
		ScreenList = ScreenList(v5.ScreenList, p2)
	}
end
