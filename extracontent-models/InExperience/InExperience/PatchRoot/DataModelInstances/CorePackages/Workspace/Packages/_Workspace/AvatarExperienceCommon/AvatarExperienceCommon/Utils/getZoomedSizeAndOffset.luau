local function getZoomedSizeAndOffset(vector2: Vector2, p: number, vector2_2: Vector2?)
	local v = not vector2_2 and 0.5 or vector2_2.X
	local v2 = not vector2_2 and 0.5 or vector2_2.Y
	local v3

	if p == 0 then
		v3 = vector2.X
	else
		v3 = vector2.X / p
	end

	local v4

	if p == 0 then
		v4 = vector2.Y
	else
		v4 = vector2.Y / p
	end

	return {
		offset = Vector2.new((vector2.X - v3) * v, (vector2.Y - v4) * v2),
		size = Vector2.new(v3, v4)
	}
end

return getZoomedSizeAndOffset
