local function computeSpan(p: number, p2: number, p3: number, p4: number?, value: number?)
	local v = p - p3 * p2 * 2

	if p4 then
		v = math.min(v, p4 * p2)
	end

	return (math.max(v, value or 0))
end

return computeSpan
