local PageLoadConfig = require(script.Parent.PageLoadConfig)

function isElementInScreenBounds(p, vector2: Vector2, p2: number)
	local absolutePosition = p.AbsolutePosition
	local absoluteSize = p.AbsoluteSize

	if absoluteSize.X <= 0 or absoluteSize.Y <= 0 then
		return false
	end

	local x = absolutePosition.X
	local v = absolutePosition.X + absoluteSize.X

	local x2 = vector2.X

	local v2 = math.max(x, 0)
	local v3 = math.max(0, math.min(v, x2) - v2)

	local y = absolutePosition.Y
	local v4 = absolutePosition.Y + absoluteSize.Y

	local y2 = vector2.Y

	local v5 = math.max(y, p2)
	local v6 = math.max(0, math.min(v4, y2) - v5)

	local v7 = absoluteSize.X * PageLoadConfig.SCREEN_BOUNDS.MIN_VISIBILITY_RATIO <= v3
	local v8 = absoluteSize.Y * PageLoadConfig.SCREEN_BOUNDS.MIN_VISIBILITY_RATIO <= v6

	return v7 and v8
end

return isElementInScreenBounds
