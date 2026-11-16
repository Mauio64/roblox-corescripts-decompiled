local MathUtil = {}

function MathUtil.lerp(p: number, p2: number, p3: number)
	return p2 * p3 + p * (1 - p3)
end

function MathUtil.inverseLerp(p: number, p2: number, p3: number)
	if p2 - p == 0 then
		return 0
	end

	return (p3 - p) / (p2 - p)
end

function MathUtil.signedPow(p: number, p2: number)
	return math.pow(math.abs(p), p2) * math.sign(p)
end

function MathUtil.log(p: number, p2: number)
	if p == 10 then
		return (math.log10(p2))
	end

	return math.log(p2) / math.log(p)
end

function MathUtil.roundToNearest(p: number, p2: number)
	return math.round(p / p2) * p2
end

return MathUtil
