local function getRevealScrollOffset(p2, p3, p4, p5, p6, value)
	if p5 <= 0 then
		return nil
	end

	local v5 = math.clamp(value, 0, (math.max(0, (p5 - p3) * 0.5)))
	local v6 = math.max(0, p6 - p5)
	local v7

	if p2 - v5 < p4 then
		v7 = p2 - v5
	else
		local v8 = p2 + p3 + v5
		v7 = if p4 + p5 < v8 then p2 + p3 + v5 - p5 else p4
	end

	local v8 = math.clamp(v7, 0, v6)

	if math.abs(v8 - p4) < 1 then
		return nil
	end

	return v8
end

return getRevealScrollOffset
