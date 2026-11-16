local function isPointOverTrashTarget(vector2: Vector2, vector2_2: Vector2, vector2_3: Vector2, vector2_4: Vector2, p: number): boolean
	local v = vector2 - vector2_2
	return v.X >= vector2_3.X - p
		and v.X <= vector2_3.X + vector2_4.X + p
		and v.Y >= vector2_3.Y - p
		and v.Y <= vector2_3.Y + vector2_4.Y + p
end

return isPointOverTrashTarget
