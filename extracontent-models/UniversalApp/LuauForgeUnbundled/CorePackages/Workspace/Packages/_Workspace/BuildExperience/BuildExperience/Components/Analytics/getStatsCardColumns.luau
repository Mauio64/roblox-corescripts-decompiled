local function getStatsCardColumns(p2): number
	if p2 >= 292 then
		return 2
	end

	return 1
end

return getStatsCardColumns
