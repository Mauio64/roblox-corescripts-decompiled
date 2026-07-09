local function getZoomedSizeAndOffset(vector2: Vector2, n1: number, vector2_2: Vector2?) -- line: 7
	local v5 = not vector2_2 and 0.5 or vector2_2.X
	local v6 = not vector2_2 and 0.5 or vector2_2.Y
	local v7 = if n1 ~= 0 then vector2.X / n1 else vector2.X
	local v8 = if n1 ~= 0 then vector2.Y / n1 else vector2.Y

	return {
		offset = Vector2.new((vector2.X - v7) * v5, (vector2.Y - v8) * v6),
		size = Vector2.new(v7, v8)
	}
end

return getZoomedSizeAndOffset
