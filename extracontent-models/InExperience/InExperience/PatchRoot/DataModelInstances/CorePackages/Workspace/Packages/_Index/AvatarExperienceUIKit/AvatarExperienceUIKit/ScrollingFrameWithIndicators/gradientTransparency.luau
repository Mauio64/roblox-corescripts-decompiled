local function fitKeypoints(numberSequenceKeypoints)
	local numberSequenceKeypoints2 = {}

	for _, item in numberSequenceKeypoints do
		local v = math.clamp(item.Time, 0, 1)
		local value = item.Value
		local v2 = numberSequenceKeypoints2[#numberSequenceKeypoints2]

		if v2 == nil then
			table.insert(numberSequenceKeypoints2, NumberSequenceKeypoint.new(0, value))
		elseif v2.Time < v then
			table.insert(numberSequenceKeypoints2, NumberSequenceKeypoint.new(v, value))
		end
	end

	local v = numberSequenceKeypoints2[#numberSequenceKeypoints2]

	if v == nil then
		return { NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 1) }
	end

	if v.Time < 1 then
		table.insert(numberSequenceKeypoints2, NumberSequenceKeypoint.new(1, v.Value))
	end

	return numberSequenceKeypoints2
end

return {
	fittedGradientTransparency = function(list, p: number, p2: number)
		local v = 1 - p2
		local v2 = math.clamp(v * list[1], 0, 1)
		local v3 = math.clamp(v * list[2], 0, 1)
		local item = list[3]

		if item < 1 then
			return nil
		end

		local v4 = item < p and 1 or p / item

		local v5 = (not (v2 > 0) and 0 or v4 * (v2 + 1)) + (not (v3 > 0) and 0 or v4 * (v3 + 1))

		if v5 > 1 then
			v4 /= v5
		end

		local numberSequenceKeypoints = {}

		if v2 > 0 then
			table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(0, 1 - v2))
			table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(v4, 1 - v2))
			table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(v4 + v4 * v2, 1))
		else
			table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(0, 1))
		end

		if v3 > 0 then
			table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(1 - v4 * v3 - v4, 1))

			table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(1 - v4, 1 - v3))
			table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(1, 1 - v3))
		else
			table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(1, 1))
		end

		return NumberSequence.new(fitKeypoints(numberSequenceKeypoints))
	end
}
