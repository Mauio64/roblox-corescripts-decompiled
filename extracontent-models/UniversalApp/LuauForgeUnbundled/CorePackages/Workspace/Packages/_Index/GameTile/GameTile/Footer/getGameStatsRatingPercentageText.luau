local function getGameStatsRatingPercentageText(p2, p3)
	local v5 = (p2 == nil or p2 < 0) and 0 or p2

	local v6 = v5 + ((p3 == nil or p3 < 0) and 0 or p3)

	return not (v6 > 0) and "--" or tostring((math.floor(v5 / v6 * 100)))
end

return getGameStatsRatingPercentageText
