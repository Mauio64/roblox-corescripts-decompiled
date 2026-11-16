local function computeSeekFraction(p2, p3, p4)
	if p4 <= 0 then
		return 0
	end

	return (math.clamp((p2 - p3) / p4, 0, 1))
end

return computeSeekFraction
