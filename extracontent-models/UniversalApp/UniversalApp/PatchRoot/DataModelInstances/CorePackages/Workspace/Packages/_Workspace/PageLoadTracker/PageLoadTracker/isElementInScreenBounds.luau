local PageLoadConfig = require(script.Parent.PageLoadConfig)

function isElementInScreenBounds(p1, vector2: Vector2, n1: number) -- line: 3
	-- upvalues: PageLoadConfig (copy)
	local AbsolutePosition = p1.AbsolutePosition
	local AbsoluteSize = p1.AbsoluteSize

	if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
		return false
	end

	local AbsolutePositionX = AbsolutePosition.X
	local v8 = AbsolutePosition.X + AbsoluteSize.X
	local vector2X = vector2.X
	local v10 = math.max(AbsolutePositionX, 0)
	local v11 = math.max(0, math.min(v8, vector2X) - v10)
	local AbsolutePositionY = AbsolutePosition.Y
	local v13 = AbsolutePosition.Y + AbsoluteSize.Y
	local vector2Y = vector2.Y
	local v15 = math.max(AbsolutePositionY, n1)
	local v16 = math.max(0, math.min(v13, vector2Y) - v15)
	local v17 = v11 >= AbsoluteSize.X * PageLoadConfig.SCREEN_BOUNDS.MIN_VISIBILITY_RATIO
	local v18 = v16 >= AbsoluteSize.Y * PageLoadConfig.SCREEN_BOUNDS.MIN_VISIBILITY_RATIO

	return v17 and v18
end

return isElementInScreenBounds
