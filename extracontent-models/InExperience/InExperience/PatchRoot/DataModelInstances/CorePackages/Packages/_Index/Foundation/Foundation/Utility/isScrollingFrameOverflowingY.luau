local function isScrollingFrameOverflowingY(p, p2: number?): boolean
	local v = p2 == nil and 1 or p2

	return p.AbsoluteCanvasSize.Y > p.AbsoluteWindowSize.Y + v
end

return isScrollingFrameOverflowingY
