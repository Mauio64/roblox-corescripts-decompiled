local function getCenterSheetHeight(p: number, p2: number, p3: number, p4: number)
	if p <= p2 then
		return p4
	end

	local v = (math.min(p, p3) - p2) * p4
	return if v > 1 then v else p4
end

return getCenterSheetHeight
