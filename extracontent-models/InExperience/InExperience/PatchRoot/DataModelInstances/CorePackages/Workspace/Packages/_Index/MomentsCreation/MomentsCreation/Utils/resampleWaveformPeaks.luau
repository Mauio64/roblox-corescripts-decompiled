local function resampleWaveformPeaks(list, p: number, min: number, max: number)
	local count = #list
	local result = {}

	for i = 1, p do
		local v

		if count > 0 then
			local v2 = math.floor((i - 1) / p * count) + 1
			local maxValue = 0

			for j = v2, math.max(v2, (math.floor(i / p * count))) do
				maxValue = math.max(maxValue, list[j])
			end

			v = math.clamp(maxValue, min, max)
		else
			v = min
		end

		table.insert(result, v)
	end

	return result
end

return resampleWaveformPeaks
