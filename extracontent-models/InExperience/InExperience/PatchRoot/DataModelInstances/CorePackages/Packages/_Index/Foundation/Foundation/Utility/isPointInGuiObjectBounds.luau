local function isPointInGuiObjectBounds(p1, vector2: Vector2) -- line: 1
	if not p1 then
		return false
	end

	local AbsolutePosition = p1.AbsolutePosition
	local AbsoluteSize = p1.AbsoluteSize
	local AbsolutePositionX = AbsolutePosition.X
	local AbsolutePositionY = AbsolutePosition.Y
	local v8 = AbsolutePosition.X + AbsoluteSize.X
	local v9 = AbsolutePosition.Y + AbsoluteSize.Y

	return AbsolutePositionX <= vector2.X and (v8 >= vector2.X and (AbsolutePositionY <= vector2.Y and v9 >= vector2.Y))
end

return isPointInGuiObjectBounds
