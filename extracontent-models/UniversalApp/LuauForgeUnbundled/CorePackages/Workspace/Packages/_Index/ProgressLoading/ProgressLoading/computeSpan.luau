local function computeSpan(p2, p3, p4, p5, value)
	local v6 = p2 - 2 * (p4 * p3)

	if p5 then
		v6 = math.min(v6, p5 * p3)
	end

	return (math.max(v6, value or 0))
end

return computeSpan
