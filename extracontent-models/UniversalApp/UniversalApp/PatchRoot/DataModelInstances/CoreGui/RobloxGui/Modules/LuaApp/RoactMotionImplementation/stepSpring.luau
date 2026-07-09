return function(p1, p2, p3, p4, p5, p6, p7) -- line: 16
	local v8 = p2 - p4
	local v9 = p3 + (-p5 * v8 + -p6 * p3) * p1
	local v10 = p2 + p3 * p1

	if p7 > math.abs(v9) and p7 > math.abs(p4 - v10) then
		return p4, 0
	end

	return v10, v9
end
