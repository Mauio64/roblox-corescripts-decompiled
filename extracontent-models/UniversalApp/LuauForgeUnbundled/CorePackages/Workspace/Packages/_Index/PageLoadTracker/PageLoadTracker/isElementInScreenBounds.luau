local PageLoadConfig = require("@game/CorePackages/Workspace/Packages/_Index/PageLoadTracker/PageLoadTracker/PageLoadConfig")

function LUAUFORGE_MODULE_GLOBALS_dDf_isElementInScreenBounds(p2, p3, p4)
	local absolutePosition = p2.AbsolutePosition
	local absoluteSize = p2.AbsoluteSize

	if absoluteSize.X <= 0 or absoluteSize.Y <= 0 then
		return false
	end

	local x = absolutePosition.X
	local v5 = absolutePosition.X + absoluteSize.X

	local x2 = p3.X

	local v6 = math.max(x, 0)
	local v7 = math.max(0, math.min(v5, x2) - v6)

	local y = absolutePosition.Y
	local v8 = absolutePosition.Y + absoluteSize.Y

	local y2 = p3.Y

	local v9 = math.max(y, p4)
	local v10 = math.max(0, math.min(v8, y2) - v9)

	local v11 = absoluteSize.X * PageLoadConfig.SCREEN_BOUNDS.MIN_VISIBILITY_RATIO <= v7
	local v12 = absoluteSize.Y * PageLoadConfig.SCREEN_BOUNDS.MIN_VISIBILITY_RATIO <= v10

	return v11 and v12
end

return LUAUFORGE_MODULE_GLOBALS_dDf_isElementInScreenBounds
