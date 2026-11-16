local v = { columns = 0, rows = 0, cardSize = Vector2.zero }

local function resolveGridLayout(vector2: Vector2, p: number, p2: number)
	if p <= 0 or vector2.X <= 0 or vector2.Y <= 0 then
		return v
	end

	local v2 = v
	local v3 = 0

	for i = 1, p do
		local rows = math.ceil(p / i)
		local v4 = math.min((vector2.X - (i - 1) * p2) / i, (vector2.Y - (rows - 1) * p2) / rows * 0.75)

		if not (v3 < v4) then
			continue
		end

		v2 = {
			columns = i,
			rows = rows,
			cardSize = Vector2.new(math.floor(v4), (math.floor(v4 / 0.75)))
		}
		v3 = v4
	end

	return v2
end

return resolveGridLayout
