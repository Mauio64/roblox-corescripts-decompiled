local function isPointWithinBounds(p2, p3, p4): boolean
	return math.clamp(p2.X, p3.X, p3.X + p4.X) == p2.X and math.clamp(p2.Y, p3.Y, p3.Y + p4.Y) == p2.Y
end

return isPointWithinBounds
