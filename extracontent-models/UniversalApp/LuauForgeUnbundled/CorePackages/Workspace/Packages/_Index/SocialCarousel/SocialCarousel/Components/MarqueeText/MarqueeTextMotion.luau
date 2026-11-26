local v5 = { ar = true, fa = true, he = true, ur = true }

local function advanceMarquee(data, p2, p3, p4, p5)
	if data.finished or p2 <= 0 or p5 <= 0 then
		return { offset = 0, loopsCompleted = data.loopsCompleted, finished = true }
	end

	if p3 <= 0 or p4 <= 0 or p2 <= data.offset then
		return data
	end

	local v6 = data.offset + p3 * p4
	local loopsCompleted = data.loopsCompleted

	while p2 <= v6 and loopsCompleted < p5 do
		v6 -= p2
		loopsCompleted += 1
	end

	if p5 <= loopsCompleted then
		return { offset = 0, loopsCompleted = loopsCompleted, finished = true }
	end

	return { offset = v6, loopsCompleted = loopsCompleted, finished = false }
end

return {
	DEFAULT_SPEED = 25,
	DEFAULT_MAX_LOOPS = 2,
	GAP = 24,
	textDirectionFromLocale = function(value)
		if v5[string.lower(string.match(value, "^([^%-]+)") or value)] then
			return Enum.TextDirection.RightToLeft
		end

		return Enum.TextDirection.LeftToRight
	end,
	travelDistance = function(p2, p3)
		if p2 <= 0 or p3 <= 0 then
			return 0
		end

		return (math.max(p2 + 24, p3))
	end,
	overflows = function(p2, p3): boolean
		return p3 > 0 and p3 < p2
	end,
	advance = advanceMarquee,
	signedOffset = function(p2, p3)
		if p3 == Enum.TextDirection.RightToLeft then
			return p2
		end

		return -p2
	end
}
