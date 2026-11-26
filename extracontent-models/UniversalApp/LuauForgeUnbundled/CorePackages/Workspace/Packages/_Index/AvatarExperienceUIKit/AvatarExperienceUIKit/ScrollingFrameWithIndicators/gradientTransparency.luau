local function fitKeypoints(numberSequenceKeypoints)
	local numberSequenceKeypoints2 = {}

	for k, item in numberSequenceKeypoints do
		local v5 = math.clamp(item.Time, 0, 1)
		local value = item.Value
		local v6 = numberSequenceKeypoints2[#numberSequenceKeypoints2]

		if v6 == nil then
			table.insert(numberSequenceKeypoints2, NumberSequenceKeypoint.new(0, value))
		elseif v6.Time < v5 then
			table.insert(numberSequenceKeypoints2, NumberSequenceKeypoint.new(v5, value))
		end
	end

	local v5 = numberSequenceKeypoints2[#numberSequenceKeypoints2]

	if v5 == nil then
		return { NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 1) }
	end

	if v5.Time < 1 then
		table.insert(numberSequenceKeypoints2, NumberSequenceKeypoint.new(1, v5.Value))
	end

	return numberSequenceKeypoints2
end

return {
	fittedGradientTransparency = function(list, p2, p3)
		local v5 = 1 - p3
		local v6 = math.clamp(v5 * list[1], 0, 1)
		local v7 = math.clamp(v5 * list[2], 0, 1)
		local item = list[3]

		if item < 1 then
			return nil
		end

		local v8 = item < p2 and 1 or p2 / item

		local v9 = (not (v6 > 0) and 0 or v8 * (v6 + 1)) + (not (v7 > 0) and 0 or v8 * (v7 + 1))

		if v9 > 1 then
			v8 /= v9
		end

		local numberSequenceKeypoints = {}

		if v6 > 0 then
			table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(0, 1 - v6))
			table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(v8, 1 - v6))
			table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(v8 + v8 * v6, 1))
		else
			table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(0, 1))
		end

		if v7 > 0 then
			table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(1 - v8 * v7 - v8, 1))

			table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(1 - v8, 1 - v7))
			table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(1, 1 - v7))
		else
			table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(1, 1))
		end

		return NumberSequence.new(fitKeypoints(numberSequenceKeypoints))
	end
}
