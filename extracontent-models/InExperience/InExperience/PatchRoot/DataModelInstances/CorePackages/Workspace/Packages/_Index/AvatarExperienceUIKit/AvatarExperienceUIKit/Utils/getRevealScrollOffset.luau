local function getRevealScrollOffset(p: number, p2: number, p3: number, p4: number, p5: number, value: number)
	if p4 <= 0 then
		return nil
	end

	local v = math.clamp(value, 0, (math.max(0, (p4 - p2) * 0.5)))
	local v2 = math.max(0, p5 - p4)
	local v3

	if p - v < p3 then
		v3 = p - v
	else
		local v4 = p + p2 + v

		if p3 + p4 < v4 then
			v3 = p + p2 + v - p4
		else
			v3 = p3
		end
	end

	local v4 = math.clamp(v3, 0, v2)
	return if not (math.abs(v4 - p3) < 1) then v4 else nil
end

return getRevealScrollOffset
