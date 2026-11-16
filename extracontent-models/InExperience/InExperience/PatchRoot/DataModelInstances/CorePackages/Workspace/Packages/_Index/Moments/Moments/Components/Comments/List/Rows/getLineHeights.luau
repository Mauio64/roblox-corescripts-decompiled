local function getLineHeights(p)
	local v = p.FontSize * p.LineHeight
	local offset = UDim.new(0, (v - p.FontSize) / 2).Offset
	return p.FontSize + 2 * offset, (math.round(v))
end

return getLineHeights
