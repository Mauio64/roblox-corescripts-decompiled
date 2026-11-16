local function clampAxis(value, p2, p3, p4)
	if p3 <= 0 or p4 <= 0 then
		return value
	end

	local v5 = p2 + p4 / 2
	local v6 = p2 + p3 - p4 / 2

	if v6 < v5 then
		return p2 + p3 / 2
	end

	return (math.clamp(value, v5, v6))
end

local function clampOverlayPosition(p2, p3, p4, p5, p6)
	if p3.X <= 0 or p3.Y <= 0 then
		return p2
	end

	local v5 = p5 or Vector2.zero
	local v6 = p6 or p3
	local v7 = p2.X.Scale * p3.X + p2.X.Offset
	local v8 = p2.Y.Scale * p3.Y + p2.Y.Offset
	local x = v5.X
	local x2 = v6.X
	local x3 = p4.X

	if not (x2 <= 0 or x3 <= 0) then
		local v9 = x + x3 / 2
		local v10 = x + x2 - x3 / 2

		v7 = if v10 < v9 then x + x2 / 2 else math.clamp(v7, v9, v10)
	end

	local y = v5.Y
	local y2 = v6.Y
	local y3 = p4.Y

	if not (y2 <= 0 or y3 <= 0) then
		local v9 = y + y3 / 2
		local v10 = y + y2 - y3 / 2

		v8 = if v10 < v9 then y + y2 / 2 else math.clamp(v8, v9, v10)
	end

	return UDim2.fromScale(v7 / p3.X, v8 / p3.Y)
end

return clampOverlayPosition
