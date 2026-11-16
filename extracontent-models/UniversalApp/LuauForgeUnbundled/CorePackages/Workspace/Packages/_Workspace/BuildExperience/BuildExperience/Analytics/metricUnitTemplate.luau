local AnalyticsKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsKeys")
local AnalyticsUnit = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsUnit")

return {
	templateFor = function(p2)
		if p2 == AnalyticsUnit.Percent then
			return AnalyticsKeys.ANALYTICS_PERCENT_TEMPLATE
		end

		if p2 == AnalyticsUnit.Minutes then
			return AnalyticsKeys.ANALYTICS_DURATION_MINUTES_TEMPLATE
		end

		if p2 == AnalyticsUnit.Temporal then
			return AnalyticsKeys.ANALYTICS_DURATION_TEMPLATE
		end

		return nil
	end,
	fillTemplate = function(value, p2)
		return (string.gsub(value, "{number}", function()
			return p2
		end))
	end
}
