local function getOverflowWindowStart(p: number) -- 1 equivalent call inferred from this helper
	return (math.max(p - 2, 1))
end

local function getDefaultDots(p: number, p2: number, size: number)
	local defaultDots = {}

	for i = 1, p2 do
		table.insert(defaultDots, {
			isActive = i == p,
			page = i,
			size = size
		})
	end

	return defaultDots
end

local function getOverflowDots(p: number, p2: number, p3: number, p4: number, p5: number)
	local overflowDots = {}

	for i = p3, math.min(p + 2, p2) do
		local v = {
			isActive = i == p,
			page = i,
			size = 0
		}

		local size = if math.abs(i - p) == 2 then p5 else p4
		v.size = size
		table.insert(overflowDots, v)
	end

	return overflowDots
end

local function getCarouselIndicatorDotsConfig(size: number, p: number, p2: number, p3: number)
	local count = math.max(math.floor(p3), 1)
	local page = math.clamp(math.floor(p2), 1, count)
	local v = math.min(count, 5)
	local v2 = count > 5
	local v3 = not v2 and 1 or getOverflowWindowStart(page) -- inferred equivalent call
	local activeVisibleIndex = page - v3 + 1
	local dots

	if v2 then
		dots = getOverflowDots(page, count, v3, size, p)
	else
		dots = getDefaultDots(page, v, size)
	end

	return { activeVisibleIndex = activeVisibleIndex, page = page, dots = dots, count = count }
end

return getCarouselIndicatorDotsConfig
