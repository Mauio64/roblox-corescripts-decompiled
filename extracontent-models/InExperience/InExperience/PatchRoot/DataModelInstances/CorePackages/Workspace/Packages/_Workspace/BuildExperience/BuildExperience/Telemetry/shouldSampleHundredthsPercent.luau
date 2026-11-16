local function shouldSampleHundredthsPercent(p: number): boolean
	return not (p <= 0) and (p >= 10000 or math.random(1, 10000) <= p)
end

return shouldSampleHundredthsPercent
