require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAnalytics")
local AnalyticsMetric = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsMetric")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsWindow")
local useExperienceMetricSeries = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/useExperienceMetricSeries")

local function useOverviewStats(p2, p3, p4)
	local function latestFor(p5)
		if p4 == nil then
			return nil
		end

		return p4[p5.id]
	end

	local dailyActiveUsers = AnalyticsMetric.DailyActiveUsers

	local dailyActiveUsers2 = AnalyticsMetric.DailyActiveUsers
	local v6 = if p4 ~= nil then p4[dailyActiveUsers2.id] else nil

	local v7 = useExperienceMetricSeries(p2, dailyActiveUsers, p3, v6)

	local totalPlaytime = AnalyticsMetric.TotalPlaytime

	local totalPlaytime2 = AnalyticsMetric.TotalPlaytime
	local v9 = if p4 ~= nil then p4[totalPlaytime2.id] else nil

	local v10 = useExperienceMetricSeries(p2, totalPlaytime, p3, v9)

	local playthroughRate = AnalyticsMetric.PlaythroughRate

	local playthroughRate2 = AnalyticsMetric.PlaythroughRate
	local v12 = if p4 ~= nil then p4[playthroughRate2.id] else nil

	local v13 = useExperienceMetricSeries(p2, playthroughRate, p3, v12)

	local d1Retention = AnalyticsMetric.D1Retention

	local d1Retention2 = AnalyticsMetric.D1Retention
	local v15 = if p4 ~= nil then p4[d1Retention2.id] else nil

	local v16 = useExperienceMetricSeries(p2, d1Retention, p3, v15)

	local payerConversion = AnalyticsMetric.PayerConversion

	local payerConversion2 = AnalyticsMetric.PayerConversion
	local v18 = if p4 ~= nil then p4[payerConversion2.id] else nil

	local v19 = useExperienceMetricSeries(p2, payerConversion, p3, v18)

	local arppu = AnalyticsMetric.Arppu
	local arppu2 = AnalyticsMetric.Arppu
	local v21 = if p4 ~= nil then p4[arppu2.id] else nil

	local v22 = useExperienceMetricSeries(p2, arppu, p3, v21)

	return {
		[AnalyticsMetric.DailyActiveUsers.id] = v7,
		[AnalyticsMetric.TotalPlaytime.id] = v10,
		[AnalyticsMetric.PlaythroughRate.id] = v13,
		[AnalyticsMetric.D1Retention.id] = v16,
		[AnalyticsMetric.PayerConversion.id] = v19,
		[AnalyticsMetric.Arppu.id] = v22
	}
end

return useOverviewStats
