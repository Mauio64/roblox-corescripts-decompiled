local function clampAxis(value: number, p: number, p2: number, p3: number) -- 2 equivalent calls inferred from this helper
	if p2 <= 0 or p3 <= 0 then
		return value
	end

	local v = p + p3 / 2
	local v2 = p + p2 - p3 / 2

	if v2 < v then
		return p + p2 / 2
	end

	return (math.clamp(value, v, v2))
end

local function clampOverlayPosition(udim: UDim2, vector2: Vector2, vector2_2: Vector2, vector2_3: Vector2?, vector2_4: Vector2?)
	if vector2.X <= 0 or vector2.Y <= 0 then
		return udim
	end

	local v = vector2_3 or Vector2.zero
	local v2 = vector2_4 or vector2
	local v3 = udim.X.Scale * vector2.X + udim.X.Offset
	local v4 = udim.Y.Scale * vector2.Y + udim.Y.Offset
	v3 = clampAxis(v3, v.X, v2.X, vector2_2.X) -- inferred equivalent call
	v4 = clampAxis(v4, v.Y, v2.Y, vector2_2.Y) -- inferred equivalent call

	return UDim2.fromScale(v3 / vector2.X, v4 / vector2.Y)
end

return clampOverlayPosition
