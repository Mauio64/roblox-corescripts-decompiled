local function formatInputSliderValue(p: number)
	local v = math.floor(p * 1000 + 0.5) / 1000

	return (tostring(v == 0 and 0 or v))
end

return formatInputSliderValue
