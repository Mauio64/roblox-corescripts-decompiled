return {
	clampBetween0And1 = function(p1) -- line: 8
		if math.abs(p1) < 0.001 then
			return 0, false
		end

		if math.abs(p1 - 1) < 0.001 then
			return 1, false
		end

		if p1 >= 0 and p1 <= 1 then
			return p1, false
		end

		return math.clamp(p1, 0, 1), true
	end
}
