return function(n1: number, n2: number, n3: number) -- line: 3
	if n2 <= 0 then
		return NumberSequence.new(0)
	end

	local v4 = math.clamp(n3, 0, 1)
	local v5 = math.clamp(n1 / n2, 0, 1)

	if v4 == 0 or v5 == 0 then
		return NumberSequence.new(0)
	end

	if v5 == 1 then
		return NumberSequence.new(v4)
	end

	if v5 <= 0.001 then
		return NumberSequence.new({
			NumberSequenceKeypoint.new(0, v4),
			NumberSequenceKeypoint.new(v5, 0),
			NumberSequenceKeypoint.new(1, 0)
		})
	end

	return NumberSequence.new({
		NumberSequenceKeypoint.new(0, v4),
		NumberSequenceKeypoint.new(v5 - 0.001, v4),
		NumberSequenceKeypoint.new(v5, 0),
		NumberSequenceKeypoint.new(1, 0)
	})
end
