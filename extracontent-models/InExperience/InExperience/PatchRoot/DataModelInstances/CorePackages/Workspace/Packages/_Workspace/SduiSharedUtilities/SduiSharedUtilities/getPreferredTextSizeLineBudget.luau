local function getPreferredTextSizeLineBudget(p: number, value: number?)
	return p * math.max(value or 0, 0)
end

return getPreferredTextSizeLineBudget
