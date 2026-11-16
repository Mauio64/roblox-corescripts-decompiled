local function normalizeWaveform(items)
	local result = {}
	local maxValue = 0

	for _, item in items do
		local v = math.abs(item)
		table.insert(result, v)
		maxValue = math.max(maxValue, v)
	end

	if maxValue == 0 then
		return result
	end

	local result2 = {}

	for _, v in result do
		table.insert(result2, v / maxValue)
	end

	return result2
end

return normalizeWaveform
