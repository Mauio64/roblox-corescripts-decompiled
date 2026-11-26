local frozen = table.freeze({ min = Vector2.zero, max = Vector2.zero })

local function intersectBounds(p2, p3)
	local v5 = {
		min = Vector2.new(math.max(p2.min.X, p3.min.X), (math.max(p2.min.Y, p3.min.Y))),
		max = Vector2.new(math.min(p2.max.X, p3.max.X), (math.min(p2.max.Y, p3.max.Y)))
	}

	if v5.min.X >= v5.max.X or v5.min.Y >= v5.max.Y then
		return frozen
	end

	return v5
end

return intersectBounds
