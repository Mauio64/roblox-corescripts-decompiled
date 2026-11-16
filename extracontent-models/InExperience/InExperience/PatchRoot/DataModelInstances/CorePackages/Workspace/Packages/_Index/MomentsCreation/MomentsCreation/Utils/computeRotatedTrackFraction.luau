local function computeRotatedTrackFraction(vector2: Vector2, vector2_2: Vector2, p: number, p2: number)
	if p <= 0 then
		return 0
	end

	local v = math.rad(p2)
	local vector2_3 = Vector2.new(math.cos(v), (math.sin(v)))
	return (math.clamp((vector2 - vector2_2):Dot(vector2_3) / p + 0.5, 0, 1))
end

return computeRotatedTrackFraction
