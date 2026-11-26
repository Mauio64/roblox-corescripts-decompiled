local function resampleWaveformPeaks(list, p2, min, max)
	local count = #list
	local result = {}

	for i = 1, p2 do
		local v5

		if count > 0 then
			local v6 = math.floor((i - 1) / p2 * count) + 1
			local maxValue = 0

			for j = v6, math.max(v6, (math.floor(i / p2 * count))) do
				maxValue = math.max(maxValue, list[j])
			end

			v5 = math.clamp(maxValue, min, max)
		else
			v5 = min
		end

		table.insert(result, v5)
	end

	return result
end

return resampleWaveformPeaks
