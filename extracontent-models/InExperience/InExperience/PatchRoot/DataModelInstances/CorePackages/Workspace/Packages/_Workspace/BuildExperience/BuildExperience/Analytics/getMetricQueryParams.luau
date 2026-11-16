local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

require(parent.DataHydration.CreatorAnalytics)
require(BuildExperience.Analytics.AnalyticsMetric)
require(BuildExperience.Analytics.AnalyticsWindow)
local FFlagBuildAnalyticsGoals = require(BuildExperience.Flags.FFlagBuildAnalyticsGoals)

local function getMetricQueryParams(universeId: number, p, p2, endTime: string)
	local metricQueryParams = {
		universeId = universeId,
		metric = p.id,
		granularity = p2.granularity,
		lookbackSeconds = p2.lookbackSeconds * 2,
		endTime = endTime,
		filters = 0
	}
	local filters

	if FFlagBuildAnalyticsGoals then
		filters = p.filters
	end

	metricQueryParams.filters = filters
	return metricQueryParams
end

return getMetricQueryParams
