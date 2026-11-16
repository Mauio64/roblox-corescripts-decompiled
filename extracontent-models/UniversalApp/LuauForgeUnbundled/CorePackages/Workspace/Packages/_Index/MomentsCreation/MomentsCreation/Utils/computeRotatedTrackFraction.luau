local function computeRotatedTrackFraction(p2, p3, p4, p5)
	if p4 <= 0 then
		return 0
	end

	local v5 = math.rad(p5)
	local vector2 = Vector2.new(math.cos(v5), (math.sin(v5)))
	return (math.clamp((p2 - p3):Dot(vector2) / p4 + 0.5, 0, 1))
end

return computeRotatedTrackFraction
