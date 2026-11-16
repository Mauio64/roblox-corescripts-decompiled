return function(p: number, p2: number, value: number)
	if p2 <= 0 then
		return NumberSequence.new(0)
	end

	local v = math.clamp(value, 0, 1)
	local v2 = math.clamp(p / p2, 0, 1)

	if v == 0 or v2 == 0 then
		return NumberSequence.new(0)
	end

	if v2 == 1 then
		return NumberSequence.new(v)
	end

	if v2 <= 0.001 then
		return NumberSequence.new({
			NumberSequenceKeypoint.new(0, v),
			NumberSequenceKeypoint.new(v2, 0),
			NumberSequenceKeypoint.new(1, 0)
		})
	end

	return NumberSequence.new({
		NumberSequenceKeypoint.new(0, v),
		NumberSequenceKeypoint.new(v2 - 0.001, v),
		NumberSequenceKeypoint.new(v2, 0),
		NumberSequenceKeypoint.new(1, 0)
	})
end
