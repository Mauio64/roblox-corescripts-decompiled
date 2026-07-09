local function isInstanceVisible(p1, vector2: Vector2, vector2_2: Vector2) -- line: 8
	local AbsoluteSize = p1.AbsoluteSize

	if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
		return false
	end

	local AbsolutePosition = p1.AbsolutePosition
	local v7 = AbsolutePosition + AbsoluteSize
	local v8 = v7.X > vector2.X and AbsolutePosition.X < vector2_2.X
	local v9 = v7.Y > vector2.Y and AbsolutePosition.Y < vector2_2.Y

	return v8 and v9
end

return isInstanceVisible
