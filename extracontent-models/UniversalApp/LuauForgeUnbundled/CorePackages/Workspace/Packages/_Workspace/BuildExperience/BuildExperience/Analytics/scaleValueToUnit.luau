local AnalyticsUnit = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsUnit")

local function scaleValueToUnit(p2, p3)
	if p3 == AnalyticsUnit.Temporal then
		return p2 * 60
	end

	return p2
end

return scaleValueToUnit
