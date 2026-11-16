local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

require(parent.DataHydration.CreatorAnalytics)
local AnalyticsMetric = require(BuildExperience.Analytics.AnalyticsMetric)
require(BuildExperience.Analytics.AnalyticsWindow)
local useExperienceMetricSeries = require(BuildExperience.Analytics.useExperienceMetricSeries)

local function useOverviewStats(p: number, p2, p3)
	local function latestFor(p4) -- 6 equivalent calls inferred from this helper
		if p3 == nil then
			return nil
		end

		return p3[p4.id]
	end

	local v = useExperienceMetricSeries(
		p,
		AnalyticsMetric.DailyActiveUsers,
		p2,
		latestFor(AnalyticsMetric.DailyActiveUsers) -- inferred equivalent call
	)

	local v2 = useExperienceMetricSeries(p, AnalyticsMetric.TotalPlaytime, p2, latestFor(AnalyticsMetric.TotalPlaytime)) -- inferred equivalent call

	local v3 = useExperienceMetricSeries(
		p,
		AnalyticsMetric.PlaythroughRate,
		p2,
		latestFor(AnalyticsMetric.PlaythroughRate) -- inferred equivalent call
	)

	local v4 = useExperienceMetricSeries(p, AnalyticsMetric.D1Retention, p2, latestFor(AnalyticsMetric.D1Retention)) -- inferred equivalent call

	local v5 = useExperienceMetricSeries(
		p,
		AnalyticsMetric.PayerConversion,
		p2,
		latestFor(AnalyticsMetric.PayerConversion) -- inferred equivalent call
	)

	local v6 = useExperienceMetricSeries(p, AnalyticsMetric.Arppu, p2, latestFor(AnalyticsMetric.Arppu)) -- inferred equivalent call

	return {
		[AnalyticsMetric.DailyActiveUsers.id] = v,
		[AnalyticsMetric.TotalPlaytime.id] = v2,
		[AnalyticsMetric.PlaythroughRate.id] = v3,
		[AnalyticsMetric.D1Retention.id] = v4,
		[AnalyticsMetric.PayerConversion.id] = v5,
		[AnalyticsMetric.Arppu.id] = v6
	}
end

return useOverviewStats
