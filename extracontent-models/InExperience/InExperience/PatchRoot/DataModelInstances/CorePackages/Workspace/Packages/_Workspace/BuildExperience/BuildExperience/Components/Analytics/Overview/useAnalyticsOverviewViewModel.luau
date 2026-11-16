local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local LocalizationService = game:GetService("LocalizationService")

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local NumberLocalization = Localization.NumberLocalization
local useLocalization = Localization.Hooks.useLocalization

local IconName = Foundation.Enums.IconName

local CreatorAnalytics = require(parent.DataHydration.CreatorAnalytics)
local DataStatus = CreatorAnalytics.DataStatus
local AnalyticsKeys = require(BuildExperience.Analytics.AnalyticsKeys)
local AnalyticsMetric = require(BuildExperience.Analytics.AnalyticsMetric)
local AnalyticsUnit = require(BuildExperience.Analytics.AnalyticsUnit)
local AnalyticsWindow = require(BuildExperience.Analytics.AnalyticsWindow)
local useMetricMetadata = require(BuildExperience.Analytics.useMetricMetadata)
local useOverviewStats = require(BuildExperience.Analytics.useOverviewStats)
local useInstantStats = require(BuildExperience.Analytics.useInstantStats)
require(BuildExperience.Components.Analytics.StatsCard.StatsCard)
require(script.Parent.InstantStatCard)
require(script.Parent.AnalyticsOverviewView)
local metricValueRoundsToZero = require(BuildExperience.Analytics.metricValueRoundsToZero)
local scaleValueToUnit = require(BuildExperience.Analytics.scaleValueToUnit)

local ids = {}

for _, overviewMetric in AnalyticsMetric.OverviewMetrics do
	table.insert(ids, overviewMetric.id)
end

local noDataPlaceholder = require(BuildExperience.Components.Analytics.noDataPlaceholder)

local function useAnalyticsOverviewViewModel(universeId: number, window2, p, metricId, callback)
	local robloxLocaleId = LocalizationService.RobloxLocaleId

	local v = useMetricMetadata(ids)
	local v2 = useOverviewStats(universeId, window2, v.latestByMetric)
	local v3 = useInstantStats(universeId)

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

	for _, overviewMetric in AnalyticsMetric.OverviewMetrics do
		clone[overviewMetric.id] = overviewMetric.titleKey
	end

	local v4 = useLocalization(clone)
	local function copy(p2: string)
		return v4[p2]
	end

	local function titleFor(p2)
		return v4[p2.id]
	end

	local statsCards = {}

	for k, overviewMetric in AnalyticsMetric.OverviewMetrics do
		local v5 = v2[overviewMetric.id]
		local statValue = scaleValueToUnit(v5.latest or 0, overviewMetric.unit)
		local v6

		if v.latestByMetric == nil then
			v6 = false
		else
			v6 = v.latestByMetric[overviewMetric.id] ~= nil
		end

		local isLoading

		if v.status == DataStatus.NotReady then
			isLoading = true
		elseif v.status == DataStatus.Ready then
			isLoading = v6 and v5.status == DataStatus.NotReady
		else
			isLoading = false
		end

		local v7

		if v5.priorValue ~= nil then
			v7 = scaleValueToUnit(v5.priorValue, overviewMetric.unit)
		end

		local v8 = v7 == nil or not metricValueRoundsToZero(v7, overviewMetric.unit, nil, robloxLocaleId)
		local deltaValue = if v8 then v5.trendPct else statValue
		local deltaUnit

		if v8 then
			deltaUnit = AnalyticsUnit.Percent
		else
			deltaUnit = overviewMetric.unit
		end

		statsCards[k] = {
			title = v4[overviewMetric.id],
			statValue = statValue,
			statUnit = overviewMetric.unit,
			statIcon = overviewMetric.icon,
			deltaValue = deltaValue,
			deltaUnit = deltaUnit,
			hasData = v5.hasData,
			isLoading = isLoading,
			isSelected = overviewMetric.id == p,
			onActivated = v5.hasData and function()
				callback(overviewMetric.id)
			end or nil,
			layoutOrder = k,
			testId = "stat-" .. overviewMetric.id
		}
	end

	local visits = v4.visits
	local players = v4.players
	local likes = v4.likes

	local instantStats = React.useMemo(function()
		local result = {}

		for k, v5 in {
			{
				key = "visits",
				label = visits,
				icon = IconName.Eye,
				value = v3.visits,
				isLoading = v3.visitsLoading
			},
			{
				key = "players",
				label = players,
				icon = IconName.ThreePeople,
				value = v3.players,
				isLoading = v3.playersLoading
			},
			{
				key = "likes",
				label = likes,
				icon = IconName.ThumbUp,
				value = v3.likes,
				isLoading = v3.likesLoading
			}
		} do
			local v6 = {
				label = v5.label,
				valueText = 0,
				icon = 0,
				isLoading = 0,
				testId = 0
			}
			local valueText

			if v5.value == nil then
				valueText = noDataPlaceholder
			else
				valueText = NumberLocalization.localize(v5.value, robloxLocaleId)
			end

			v6.valueText = valueText

			v6.icon = v5.icon
			v6.isLoading = v5.isLoading
			v6.testId = "instant-" .. v5.key
			result[k] = v6
		end

		return result
	end, { v3, robloxLocaleId, visits, players, likes })

	local windows = {}

	for k, window in AnalyticsWindow.Windows do
		windows[k] = { id = window.id, label = v4[window.id] }
	end

	local sheet

	if not (metricId == nil or AnalyticsMetric.MetricById[metricId] == nil) then
		sheet = {
			metricId = metricId,
			universeId = universeId,
			window = window2,
			latestAvailableTime = 0,
			metadataStatus = 0
		}
		local latestAvailableTime

		if v.latestByMetric ~= nil then
			latestAvailableTime = v.latestByMetric[metricId]
		end

		sheet.latestAvailableTime = latestAvailableTime

		sheet.metadataStatus = v.status
	end

	return {
		overviewTitle = v4.overviewTitle,
		keyStatsTitle = v4.keyStatsTitle,
		instantStats = instantStats,
		statsCards = statsCards,
		windows = windows,
		sheet = sheet
	}
end

return useAnalyticsOverviewViewModel
