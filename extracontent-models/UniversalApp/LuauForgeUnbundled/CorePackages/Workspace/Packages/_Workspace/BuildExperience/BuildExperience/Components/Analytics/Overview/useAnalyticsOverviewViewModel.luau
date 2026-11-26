local LocalizationService = game:GetService("LocalizationService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization")
local numberLocalization = Localization.NumberLocalization
local useLocalization = Localization.Hooks.useLocalization

local iconName = Foundation.Enums.IconName

local dataStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAnalytics").DataStatus
local AnalyticsKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsKeys")
local AnalyticsMetric = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsMetric")
local AnalyticsUnit = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsUnit")
local AnalyticsWindow = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsWindow")
local useMetricMetadata = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/useMetricMetadata")
local useOverviewStats = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/useOverviewStats")
local useInstantStats = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/useInstantStats")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/StatsCard/StatsCard")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Overview/InstantStatCard")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Overview/AnalyticsOverviewView")
local metricValueRoundsToZero = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/metricValueRoundsToZero")
local scaleValueToUnit = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/scaleValueToUnit")

local ids = {}

for k, overviewMetric in AnalyticsMetric.OverviewMetrics do
	table.insert(ids, overviewMetric.id)
end

local noDataPlaceholder = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/noDataPlaceholder")

local function useAnalyticsOverviewViewModel(p2, p3, p4, p5, callback)
	local robloxLocaleId = LocalizationService.RobloxLocaleId

	local v5 = useMetricMetadata(ids)
	local v6 = useOverviewStats(p2, p3, v5.latestByMetric)
	local v7 = useInstantStats(p2)

	local labelKeysById = {
		overviewTitle = AnalyticsKeys.ANALYTICS_OVERVIEW_TITLE,
		keyStatsTitle = AnalyticsKeys.ANALYTICS_KEY_STATS_TITLE,
		visits = AnalyticsKeys.ANALYTICS_INSTANT_VISITS,
		players = AnalyticsKeys.ANALYTICS_INSTANT_PLAYERS,
		likes = AnalyticsKeys.ANALYTICS_INSTANT_LIKES,
		[AnalyticsWindow.LastWeek.id] = AnalyticsWindow.LastWeek.labelKey,
		[AnalyticsWindow.LastMonth.id] = AnalyticsWindow.LastMonth.labelKey
	}

	local clone = table.clone(labelKeysById)

	for k, overviewMetric in AnalyticsMetric.OverviewMetrics do
		clone[overviewMetric.id] = overviewMetric.titleKey
	end

	local v8 = useLocalization(clone)
	local function copy(p6)
		return v8[p6]
	end

	local function titleFor(p6)
		return v8[p6.id]
	end

	local v9 = {}

	for k, overviewMetric in AnalyticsMetric.OverviewMetrics do
		local v10 = v6[overviewMetric.id]
		local v11 = scaleValueToUnit(v10.latest or 0, overviewMetric.unit)

		local v12 = not (v5.latestByMetric == nil) and v5.latestByMetric[overviewMetric.id] ~= nil
		local v13

		if v5.status == dataStatus.NotReady then
			v13 = true
		else
			v13 = v5.status == dataStatus.Ready and (v12 and v10.status == dataStatus.NotReady)
		end

		local v14 = if v10.priorValue ~= nil then scaleValueToUnit(v10.priorValue, overviewMetric.unit) else nil
		local v15 = v14 == nil or not metricValueRoundsToZero(v14, overviewMetric.unit, nil, robloxLocaleId)
		local v16 = if v15 then v10.trendPct else v11
		local v17 = if v15 then AnalyticsUnit.Percent else overviewMetric.unit
		v9[k] = {
			title = v8[overviewMetric.id],
			statValue = v11,
			statUnit = overviewMetric.unit,
			statIcon = overviewMetric.icon,
			deltaValue = v16,
			deltaUnit = v17,
			hasData = v10.hasData,
			isLoading = v13,
			isSelected = overviewMetric.id == p4,
			onActivated = v10.hasData and function()
				callback(overviewMetric.id)
			end or nil,
			layoutOrder = k,
			testId = "stat-" .. overviewMetric.id
		}
	end

	local visits = v8.visits
	local players = v8.players
	local likes = v8.likes

	local v10 = React.useMemo(function()
		local result = {}

		for k, v11 in {
			{
				key = "visits",
				label = visits,
				icon = iconName.Eye,
				value = v7.visits,
				isLoading = v7.visitsLoading
			},
			{
				key = "players",
				label = players,
				icon = iconName.ThreePeople,
				value = v7.players,
				isLoading = v7.playersLoading
			},
			{
				key = "likes",
				label = likes,
				icon = iconName.ThumbUp,
				value = v7.likes,
				isLoading = v7.likesLoading
			}
		} do
			local v12 = {
				label = v11.label,
				valueText = 0,
				icon = 0,
				isLoading = 0,
				testId = 0
			}
			local v13 = if v11.value == nil then noDataPlaceholder else numberLocalization.localize(v11.value, robloxLocaleId)
			v12.valueText = v13

			v12.icon = v11.icon
			v12.isLoading = v11.isLoading
			v12.testId = "instant-" .. v11.key
			result[k] = v12
		end

		return result
	end, { v7, robloxLocaleId, visits, players, likes })

	local v11 = {}

	for k, window in AnalyticsWindow.Windows do
		v11[k] = { id = window.id, label = v8[window.id] }
	end

	local v12

	if not (p5 == nil or AnalyticsMetric.MetricById[p5] == nil) then
		v12 = {
			metricId = p5,
			universeId = p2,
			window = p3,
			latestAvailableTime = 0,
			metadataStatus = 0
		}

		local v13 = if v5.latestByMetric ~= nil then v5.latestByMetric[p5] else nil
		v12.latestAvailableTime = v13

		v12.metadataStatus = v5.status
	end

	return {
		overviewTitle = v8.overviewTitle,
		keyStatsTitle = v8.keyStatsTitle,
		instantStats = v10,
		statsCards = v9,
		windows = v11,
		sheet = v12
	}
end

return useAnalyticsOverviewViewModel
