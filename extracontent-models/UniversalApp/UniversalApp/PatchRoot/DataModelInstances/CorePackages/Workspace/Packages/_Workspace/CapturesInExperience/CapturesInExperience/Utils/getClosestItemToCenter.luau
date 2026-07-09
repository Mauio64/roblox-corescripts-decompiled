local function getClosestItemToCenter(vector2: Vector2, p1) -- line: 1
	local AbsoluteSize = p1.AbsoluteSize
	local CanvasPosition = p1.CanvasPosition
	local v6 = math.floor((CanvasPosition.X + AbsoluteSize.X / 2) / vector2.X) + 1

	return v6, (math.abs(CanvasPosition.X - (v6 - 1) * vector2.X))
end

return getClosestItemToCenter
