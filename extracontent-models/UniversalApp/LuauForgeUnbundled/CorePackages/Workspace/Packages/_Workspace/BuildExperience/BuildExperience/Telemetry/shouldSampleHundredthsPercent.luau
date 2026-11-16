local function shouldSampleHundredthsPercent(p2): boolean
	if p2 <= 0 then
		return false
	end

	if p2 >= 10000 then
		return true
	end

	return math.random(1, 10000) <= p2
end

return shouldSampleHundredthsPercent
