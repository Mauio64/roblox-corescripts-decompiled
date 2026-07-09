local function clampAxis(n1: number, n2: number, n3: number, n4: number) -- line: 1
	if n3 <= 0 or n4 <= 0 then
		return n1
	end

	local v7 = n2 + n4 / 2
	local v8 = n2 + n3 - n4 / 2

	if v8 < v7 then
		return n2 + n3 / 2
	end

	return (math.clamp(n1, v7, v8))
end
local function clampTextOverlayPosition(uDim2: UDim2, vector2: Vector2, vector2_2: Vector2, vector2_3: Vector2?, vector2_4: Vector2?) -- line: 16
	if vector2.X <= 0 or vector2.Y <= 0 then
		return uDim2
	end

	local v14 = vector2_3 or Vector2.zero
	local v15 = vector2_4 or vector2
	local v16 = uDim2.X.Scale * vector2.X + uDim2.X.Offset
	local v17 = uDim2.Y.Scale * vector2.Y + uDim2.Y.Offset
	local X = v14.X
	local X2 = v15.X
	local vector2_2X = vector2_2.X

	if X2 <= 0 or vector2_2X <= 0 then
	else
		local v21 = X + vector2_2X / 2
		local v22 = X + X2 - vector2_2X / 2

		v16 = if not (v22 < v21) then math.clamp(v16, v21, v22) else X + X2 / 2
	end

	local Y = v14.Y
	local Y2 = v15.Y
	local vector2_2Y = vector2_2.Y

	if Y2 <= 0 or vector2_2Y <= 0 then
	else
		local v26 = Y + vector2_2Y / 2
		local v27 = Y + Y2 - vector2_2Y / 2

		v17 = if not (v27 < v26) then math.clamp(v17, v26, v27) else Y + Y2 / 2
	end

	return UDim2.fromScale(v16 / vector2.X, v17 / vector2.Y)
end

return clampTextOverlayPosition
