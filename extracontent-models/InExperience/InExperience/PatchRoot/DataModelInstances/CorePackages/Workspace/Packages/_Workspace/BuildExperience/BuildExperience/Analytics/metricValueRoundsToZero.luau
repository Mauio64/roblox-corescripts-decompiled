local BuildExperience = script:FindFirstAncestor("BuildExperience")

require(BuildExperience.Analytics.AnalyticsUnit)
local formatStatNumber = require(BuildExperience.Analytics.formatStatNumber)

local function metricValueRoundsToZero(p: number, p2, p3, p4: string): boolean
	return formatStatNumber(math.abs(p), p2, p3, p4) == formatStatNumber(0, p2, p3, p4)
end

return metricValueRoundsToZero
