local v = { ar = true, fa = true, he = true, ur = true }

local function advanceMarquee(data, p: number, p2: number, p3: number, p4: number)
	if data.finished or p <= 0 or p4 <= 0 then
		return { offset = 0, loopsCompleted = data.loopsCompleted, finished = true }
	end

	if p2 <= 0 or p3 <= 0 or p <= data.offset then
		return data
	end

	local offset = data.offset + p2 * p3
	local loopsCompleted = data.loopsCompleted

	while p <= offset and loopsCompleted < p4 do
		offset -= p
		loopsCompleted += 1
	end

	if p4 <= loopsCompleted then
		return { offset = 0, loopsCompleted = loopsCompleted, finished = true }
	end

	return { offset = offset, loopsCompleted = loopsCompleted, finished = false }
end

local MarqueeTextMotion = {}
MarqueeTextMotion.DEFAULT_SPEED = 25
MarqueeTextMotion.DEFAULT_MAX_LOOPS = 2
MarqueeTextMotion.GAP = 24

function MarqueeTextMotion.textDirectionFromLocale(value: string)
	if v[string.lower(string.match(value, "^([^%-]+)") or value)] then
		return Enum.TextDirection.RightToLeft
	end

	return Enum.TextDirection.LeftToRight
end

function MarqueeTextMotion.travelDistance(p: number, p2: number)
	if p <= 0 or p2 <= 0 then
		return 0
	end

	return (math.max(p + 24, p2))
end

function MarqueeTextMotion.overflows(p: number, p2: number): boolean
	return p2 > 0 and p2 < p
end

MarqueeTextMotion.advance = advanceMarquee

function MarqueeTextMotion.signedOffset(p: number, p2)
	if p2 == Enum.TextDirection.RightToLeft then
		return p
	end

	return -p
end

return MarqueeTextMotion
