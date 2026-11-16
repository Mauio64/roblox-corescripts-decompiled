local function getGameStatsRatingPercentageText(p, p2)
	local v = (p == nil or p < 0) and 0 or p

	local v2 = v + ((p2 == nil or p2 < 0) and 0 or p2)

	return not (v2 > 0) and "--" or tostring((math.floor(v / v2 * 100)))
end

return getGameStatsRatingPercentageText
