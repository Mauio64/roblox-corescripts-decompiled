local function isPointOverTrashTarget(p2, p3, p4, p5, p6): boolean
	local v5 = p2 - p3
	return v5.X >= p4.X - p6 and v5.X <= p4.X + p5.X + p6 and v5.Y >= p4.Y - p6 and v5.Y <= p4.Y + p5.Y + p6
end

return isPointOverTrashTarget
