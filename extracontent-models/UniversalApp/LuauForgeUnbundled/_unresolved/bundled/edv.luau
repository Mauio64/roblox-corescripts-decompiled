return function(p2, p3, p4, p5, p6, p7, p8)
	local v5 = p3 - p5
	local v6 = p4 + (-p6 * v5 + -p7 * p4) * p2
	local v7 = p3 + p4 * p2

	if math.abs(v6) < p8 and math.abs(p5 - v7) < p8 then
		return p5, 0
	end

	return v7, v6
end
