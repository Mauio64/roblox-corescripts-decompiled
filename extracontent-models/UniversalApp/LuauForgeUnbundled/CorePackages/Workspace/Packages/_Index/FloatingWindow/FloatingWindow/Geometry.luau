local function clampAxis(value, min, max)
	if max <= min then
		return (min + max) / 2
	end

	return (math.clamp(value, min, max))
end

return {
	hasPositiveSize = function(p2): boolean
		return p2.X > 0 and p2.Y > 0
	end,
	resolveCenter = function(p2, p3)
		return Vector2.new(p2.X.Scale * p3.X + p2.X.Offset, p2.Y.Scale * p3.Y + p2.Y.Offset)
	end,
	clampCenter = function(p2, p3, p4)
		local v6 = p4 / 2
		local newVector2 = Vector2.new
		local x = p2.X
		local x2 = v6.X
		local v7 = p3.X - v6.X
		local v8 = if v7 <= x2 then (x2 + v7) / 2 else math.clamp(x, x2, v7)

		local y = p2.Y
		local y2 = v6.Y
		local v9 = p3.Y - v6.Y
		local v10 = if v9 <= y2 then (y2 + v9) / 2 else math.clamp(y, y2, v9)

		return newVector2(v8, v10)
	end
}
