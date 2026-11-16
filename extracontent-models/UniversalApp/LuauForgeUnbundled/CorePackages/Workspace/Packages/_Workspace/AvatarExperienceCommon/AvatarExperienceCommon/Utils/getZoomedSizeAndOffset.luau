local function getZoomedSizeAndOffset(p2, p3, p4)
	local v5 = not p4 and 0.5 or p4.X
	local v6 = not p4 and 0.5 or p4.Y
	local v7 = if p3 == 0 then p2.X else p2.X / p3
	local v8 = if p3 == 0 then p2.Y else p2.Y / p3

	return {
		offset = Vector2.new((p2.X - v7) * v5, (p2.Y - v8) * v6),
		size = Vector2.new(v7, v8)
	}
end

return getZoomedSizeAndOffset
