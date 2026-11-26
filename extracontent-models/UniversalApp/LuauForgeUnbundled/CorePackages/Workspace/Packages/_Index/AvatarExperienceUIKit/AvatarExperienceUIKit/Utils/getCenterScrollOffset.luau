local function getCenterScrollOffset(p2, p3, p4, p5)
	if p5 <= 0 then
		return nil
	end

	local v5 = math.max(0, p2 + p3 * 0.5 - p5 * 0.5)

	if math.abs(v5 - p4) < 1 then
		return nil
	end

	return v5
end

return getCenterScrollOffset
