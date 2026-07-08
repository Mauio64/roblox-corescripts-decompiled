local function isScrollingFrameOverflowingY(p1, n1: number?) -- line: 1
	local v4 = n1 == nil and 1 or n1

	return p1.AbsoluteCanvasSize.Y > p1.AbsoluteWindowSize.Y + v4
end

return isScrollingFrameOverflowingY
