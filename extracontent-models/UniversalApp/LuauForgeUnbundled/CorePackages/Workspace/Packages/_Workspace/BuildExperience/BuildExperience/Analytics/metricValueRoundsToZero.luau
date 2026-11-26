require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsUnit")
local formatStatNumber = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/formatStatNumber")

local function metricValueRoundsToZero(p2, p3, p4, p5): boolean
	return formatStatNumber(math.abs(p2), p3, p4, p5) == formatStatNumber(0, p3, p4, p5)
end

return metricValueRoundsToZero
