local frozen = table.freeze({ min = Vector2.zero, max = Vector2.zero })

local function intersectBounds(p, p2)
	local v = {
		min = Vector2.new(math.max(p.min.X, p2.min.X), (math.max(p.min.Y, p2.min.Y))),
		max = Vector2.new(math.min(p.max.X, p2.max.X), (math.min(p.max.Y, p2.max.Y)))
	}

	if v.min.X >= v.max.X or v.min.Y >= v.max.Y then
		return frozen
	end

	return v
end

return intersectBounds
