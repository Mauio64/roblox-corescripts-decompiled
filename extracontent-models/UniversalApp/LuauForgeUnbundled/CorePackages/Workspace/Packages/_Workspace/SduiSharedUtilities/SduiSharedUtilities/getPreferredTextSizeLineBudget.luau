local function getPreferredTextSizeLineBudget(p2, value)
	return p2 * math.max(value or 0, 0)
end

return getPreferredTextSizeLineBudget
