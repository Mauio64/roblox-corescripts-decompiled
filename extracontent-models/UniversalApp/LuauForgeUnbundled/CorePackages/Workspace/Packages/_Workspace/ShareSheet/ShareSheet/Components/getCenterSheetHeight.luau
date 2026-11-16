local function getCenterSheetHeight(p2, p3, p4, p5)
	if p2 <= p3 then
		return p5
	end

	local v5 = (math.min(p2, p4) - p3) * p5

	if v5 > 1 then
		return v5
	end

	return p5
end

return getCenterSheetHeight
