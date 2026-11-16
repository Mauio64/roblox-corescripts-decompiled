local function computeSeekFraction(p: number, p2: number, p3: number)
	if p3 <= 0 then
		return 0
	end

	return (math.clamp((p - p2) / p3, 0, 1))
end

return computeSeekFraction
