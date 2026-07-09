local function isOnScreen(p1, p2) -- line: 1
	if not p2 then
		return true
	end

	local AbsolutePosition = p2.AbsolutePosition
	local AbsoluteSize = p2.AbsoluteSize
	local AbsolutePosition2 = p1.AbsolutePosition
	local AbsoluteSize2 = p1.AbsoluteSize
	local v8 = AbsolutePosition2.X + AbsoluteSize2.X > AbsolutePosition.X and AbsolutePosition2.X < AbsolutePosition.X + AbsoluteSize.X
	local v9 = AbsolutePosition2.Y + AbsoluteSize2.Y > AbsolutePosition.Y and AbsolutePosition2.Y < AbsolutePosition.Y + AbsoluteSize.Y

	return v8 and v9
end

return isOnScreen
