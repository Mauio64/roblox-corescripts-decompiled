local function getStatsCardColumns(p: number): number
	return if p >= 292 then 2 else 1
end

return getStatsCardColumns
