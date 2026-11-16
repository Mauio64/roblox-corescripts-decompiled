return {
	MIN_VISIBLE_FRACTION = 0.7,
	tileVisibilityFraction = function(p2, p3, p4, p5, p6)
		if p2 < 1 or p5 <= 0 or p4 <= 0 then
			return 0
		end

		local v5 = (p2 - 1) * (p5 + p6)
		return math.max(0, math.min(v5 + p5, p3 + p4) - math.max(v5, p3)) / p5
	end,
	verticalVisibilityFraction = function(p2, p3, p4, p5)
		if p3 <= 0 or p5 <= 0 then
			return 0
		end

		return math.max(0, math.min(p2 + p3, p4 + p5) - math.max(p2, p4)) / p3
	end,
	isAtLeast70PercentVerticallyVisible = function(p2, p3, p4, p5): boolean
		return ((p3 <= 0 or p5 <= 0) and 0 or math.max(0, math.min(p2 + p3, p4 + p5) - math.max(p2, p4)) / p3) >= 0.7
	end,
	isAtLeast70PercentVisible = function(p2, p3, p4, p5, p6): boolean
		local v5

		if p2 < 1 or p5 <= 0 or p4 <= 0 then
			v5 = 0
		else
			local v6 = (p2 - 1) * (p5 + p6)
			v5 = math.max(0, math.min(v6 + p5, p3 + p4) - math.max(v6, p3)) / p5
		end

		return v5 >= 0.7
	end
}
