local function getGameStatsRatingPercentageText(p1, p2) -- line: 1
	local s1 = "--"

	if p1 == nil or p1 < 0 then
		p1 = 0
	end

	if p2 == nil or p2 < 0 then
		p2 = 0
	end

	local v5 = p1 + p2

	if v5 > 0 then
		s1 = tostring((math.floor(p1 / v5 * 100)))
	end

	return s1
end

return getGameStatsRatingPercentageText
