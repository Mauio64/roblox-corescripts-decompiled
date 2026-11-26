local function normalizeWaveform(items)
	local result = {}
	local maxValue = 0

	for k, item in items do
		local v5 = math.abs(item)
		table.insert(result, v5)
		maxValue = math.max(maxValue, v5)
	end

	if maxValue == 0 then
		return result
	end

	local result2 = {}

	for k, v5 in result do
		table.insert(result2, v5 / maxValue)
	end

	return result2
end

return normalizeWaveform
