local BuildExperience = script:FindFirstAncestor("BuildExperience")

local AnalyticsKeys = require(BuildExperience.Analytics.AnalyticsKeys)
local AnalyticsUnit = require(BuildExperience.Analytics.AnalyticsUnit)
local MetricUnitTemplate = {}

function MetricUnitTemplate.templateFor(p)
	if p == AnalyticsUnit.Percent then
		return AnalyticsKeys.ANALYTICS_PERCENT_TEMPLATE
	end

	if p == AnalyticsUnit.Minutes then
		return AnalyticsKeys.ANALYTICS_DURATION_MINUTES_TEMPLATE
	end

	if p == AnalyticsUnit.Temporal then
		return AnalyticsKeys.ANALYTICS_DURATION_TEMPLATE
	end

	return nil
end

function MetricUnitTemplate.fillTemplate(value: string, p: string)
	return (string.gsub(value, "{number}", function()
		return p
	end))
end

return MetricUnitTemplate
