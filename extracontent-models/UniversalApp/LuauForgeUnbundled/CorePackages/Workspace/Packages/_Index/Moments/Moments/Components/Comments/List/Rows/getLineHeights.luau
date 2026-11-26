local function getLineHeights(p2)
	local v5 = p2.FontSize * p2.LineHeight
	local offset = UDim.new(0, (v5 - p2.FontSize) / 2).Offset
	return p2.FontSize + 2 * offset, (math.round(v5))
end

return getLineHeights
