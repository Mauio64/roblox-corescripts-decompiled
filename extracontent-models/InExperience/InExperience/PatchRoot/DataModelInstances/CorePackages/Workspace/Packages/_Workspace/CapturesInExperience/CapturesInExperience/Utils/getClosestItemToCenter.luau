local function getClosestItemToCenter(vector2: Vector2, p)
	local absoluteSize = p.AbsoluteSize
	local canvasPosition = p.CanvasPosition

	local v = math.floor((canvasPosition.X + absoluteSize.X / 2) / vector2.X) + 1
	return v, (math.abs(canvasPosition.X - (v - 1) * vector2.X))
end

return getClosestItemToCenter
