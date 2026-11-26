return {
	getRevealOnlyCanvasY = function(p2, p3, p4, p5, p6)
		local v5 = p5 + p6

		if p5 <= p2 and p2 + p3 <= v5 then
			return nil
		end

		local v6 = p4.Y + (p2 - p5) - (p6 - p3) / 2

		if math.abs(v6 - p4.Y) < 1 then
			return nil
		end

		return v6
	end
}
