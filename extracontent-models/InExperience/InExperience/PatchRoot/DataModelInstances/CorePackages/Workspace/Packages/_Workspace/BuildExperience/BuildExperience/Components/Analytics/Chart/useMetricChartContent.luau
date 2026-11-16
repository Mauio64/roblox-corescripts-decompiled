local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local LocalizationService = game:GetService("LocalizationService")

require(parent.AnalyticsMetricChart)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local AnalyticsKeys = require(BuildExperience.Analytics.AnalyticsKeys)
require(parent.DataHydration.CreatorAnalytics)
require(BuildExperience.Analytics.AnalyticsMetric)
local AnalyticsUnit = require(BuildExperience.Analytics.AnalyticsUnit)
require(BuildExperience.Analytics.AnalyticsWindow)
local fillMetricSeriesGaps = require(BuildExperience.Analytics.fillMetricSeriesGaps)
local formatMetricValue = require(BuildExperience.Analytics.formatMetricValue)
local formatMetricTimestamp = require(BuildExperience.Analytics.formatMetricTimestamp)
local metricValueRoundsToZero = require(BuildExperience.Analytics.metricValueRoundsToZero)
require(BuildExperience.Analytics.metricUnitTemplate)
local scaleValueToUnit = require(BuildExperience.Analytics.scaleValueToUnit)
local FFlagBuildAnalyticsGoals = require(BuildExperience.Flags.FFlagBuildAnalyticsGoals)

local noDataPlaceholder = require(BuildExperience.Components.Analytics.noDataPlaceholder)

local v = {
	AnalyticsKeys.ANALYTICS_MONTH_JAN,
	AnalyticsKeys.ANALYTICS_MONTH_FEB,
	AnalyticsKeys.ANALYTICS_MONTH_MAR,
	AnalyticsKeys.ANALYTICS_MONTH_APR,
	AnalyticsKeys.ANALYTICS_MONTH_MAY,
	AnalyticsKeys.ANALYTICS_MONTH_JUN,
	AnalyticsKeys.ANALYTICS_MONTH_JUL,
	AnalyticsKeys.ANALYTICS_MONTH_AUG,
	AnalyticsKeys.ANALYTICS_MONTH_SEP,
	AnalyticsKeys.ANALYTICS_MONTH_OCT,
	AnalyticsKeys.ANALYTICS_MONTH_NOV,
	AnalyticsKeys.ANALYTICS_MONTH_DEC
}

local function useMetricChartContent(data)
	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local metric = data.metric

	local unit = metric.unit

	local v2 = {
		title = metric.titleKey,
		percent = AnalyticsKeys.ANALYTICS_PERCENT_TEMPLATE,
		duration = 0
	}
	local duration

	if FFlagBuildAnalyticsGoals and unit == AnalyticsUnit.Minutes then
		duration = AnalyticsKeys.ANALYTICS_DURATION_MINUTES_TEMPLATE
	else
		duration = AnalyticsKeys.ANALYTICS_DURATION_TEMPLATE
	end

	v2.duration = duration

	for k, v3 in v do
		v2["month" .. k] = v3
	end

	local v3 = useLocalization(v2)
	local title = v3.title
	local v4 = {}

	for k, _ in v do
		v4[k] = v3["month" .. k]
	end

	local v5 = { percent = v3.percent, duration = v3.duration }

	local v6 = React.useMemo(function()
		local v6 = nil

		if data.window ~= nil and data.latestAvailableTime ~= nil then
			local dateTime = DateTime.fromIsoDate(data.latestAvailableTime)

			v6 = dateTime ~= nil
				and {
					lookbackSeconds = data.window.lookbackSeconds,
					endUnix = dateTime.UnixTimestamp
				}
				or v6
		end

		return fillMetricSeriesGaps(data.series, v6)
	end, { data.series, data.window, data.latestAvailableTime })
	local dataPoints

	if v6 ~= nil then
		dataPoints = v6.dataPoints
	end

	local v7 = v6 == nil and "None" or v6.granularity

	local v8 = scaleValueToUnit(data.latest or 0, unit)
	local valueText

	if data.hasData and data.latest ~= nil then
		valueText = formatMetricValue(v8, unit, robloxLocaleId, v5)
	else
		valueText = noDataPlaceholder
	end

	local v9

	if data.priorValue ~= nil then
		v9 = scaleValueToUnit(data.priorValue, unit)
	end

	local v10 = v9 == nil or not metricValueRoundsToZero(v9, unit, nil, robloxLocaleId)

	local deltaText = nil
	local isDeltaPositive = false

	if data.hasData then
		if v10 then
			if not metricValueRoundsToZero(data.trendPct, AnalyticsUnit.Percent, nil, robloxLocaleId) then
				deltaText = formatMetricValue(math.abs(data.trendPct), AnalyticsUnit.Percent, robloxLocaleId, v5)
				isDeltaPositive = data.trendPct > 0
			end
		elseif not metricValueRoundsToZero(v8, unit, nil, robloxLocaleId) then
			deltaText = formatMetricValue(v8, unit, robloxLocaleId, v5)
			isDeltaPositive = v8 > 0
		end
	end

	local v11 = {
		layoutOrder = data.layoutOrder,
		plotId = metric.id,
		series = dataPoints ~= nil and {
			{ id = metric.id, name = title, points = dataPoints }
		} or nil,
		hasData = data.hasData,
		title = title,
		summary = data.summary,
		valueText = valueText,
		icon = 0,
		deltaText = 0,
		isDeltaPositive = 0,
		yAxisFormatter = 0,
		xAxisFormatter = 0,
		tooltipFormatters = 0
	}
	local icon

	if not data.hideIcon then
		icon = metric.chartIcon or metric.icon
	end

	v11.icon = icon
	v11.deltaText = deltaText
	v11.isDeltaPositive = isDeltaPositive
	function v11.yAxisFormatter(p)
		return formatMetricValue(scaleValueToUnit(p.value, unit), unit, robloxLocaleId, v5)
	end

	function v11.xAxisFormatter(p)
		return formatMetricTimestamp(p.value, v7, v4)
	end

	v11.tooltipFormatters = {
		formatXForPoint = function(p: string)
			return formatMetricTimestamp(p, v7, v4)
		end,
		formatSeriesValueForPoint = function(p)
			return formatMetricValue(scaleValueToUnit(p.y, unit), unit, robloxLocaleId, v5, "Full")
		end
	}
	return v11
end

return useMetricChartContent
