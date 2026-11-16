local LocalizationService = game:GetService("LocalizationService")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/AnalyticsMetricChart")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization

local AnalyticsKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsKeys")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAnalytics")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsMetric")
local AnalyticsUnit = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsUnit")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsWindow")
local fillMetricSeriesGaps = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/fillMetricSeriesGaps")
local formatMetricValue = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/formatMetricValue")
local formatMetricTimestamp = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/formatMetricTimestamp")
local metricValueRoundsToZero = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/metricValueRoundsToZero")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/metricUnitTemplate")
local scaleValueToUnit = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/scaleValueToUnit")
local FFlagBuildAnalyticsGoals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAnalyticsGoals")

local noDataPlaceholder = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/noDataPlaceholder")

local v5 = {
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

	local v6 = {
		title = metric.titleKey,
		percent = AnalyticsKeys.ANALYTICS_PERCENT_TEMPLATE,
		duration = 0
	}
	local v7 = if FFlagBuildAnalyticsGoals and unit == AnalyticsUnit.Minutes then AnalyticsKeys.ANALYTICS_DURATION_MINUTES_TEMPLATE else AnalyticsKeys.ANALYTICS_DURATION_TEMPLATE
	v6.duration = v7

	for k, v8 in v5 do
		v6["month" .. k] = v8
	end

	local v8 = useLocalization(v6)
	local title = v8.title
	local v9 = {}

	for k, v10 in v5 do
		v9[k] = v8["month" .. k]
	end

	local v10 = { percent = v8.percent, duration = v8.duration }

	local v11 = React.useMemo(function()
		local v12 = nil

		if data.window ~= nil and data.latestAvailableTime ~= nil then
			local dateTime = DateTime.fromIsoDate(data.latestAvailableTime)

			v12 = dateTime ~= nil
				and {
					lookbackSeconds = data.window.lookbackSeconds,
					endUnix = dateTime.UnixTimestamp
				}
				or v12
		end

		return fillMetricSeriesGaps(data.series, v12)
	end, { data.series, data.window, data.latestAvailableTime })

	local dataPoints = if v11 ~= nil then v11.dataPoints else nil
	local v12 = v11 == nil and "None" or v11.granularity

	local v13 = scaleValueToUnit(data.latest or 0, unit)
	local v14

	if data.hasData and data.latest ~= nil then
		v14 = formatMetricValue(v13, unit, robloxLocaleId, v10)
	else
		v14 = noDataPlaceholder
	end

	local v15 = if data.priorValue ~= nil then scaleValueToUnit(data.priorValue, unit) else nil
	local v16 = v15 == nil or not metricValueRoundsToZero(v15, unit, nil, robloxLocaleId)

	local v17 = nil
	local v18 = false

	if data.hasData then
		if v16 then
			if not metricValueRoundsToZero(data.trendPct, AnalyticsUnit.Percent, nil, robloxLocaleId) then
				v17 = formatMetricValue(math.abs(data.trendPct), AnalyticsUnit.Percent, robloxLocaleId, v10)
				v18 = data.trendPct > 0
			end
		elseif not metricValueRoundsToZero(v13, unit, nil, robloxLocaleId) then
			v17 = formatMetricValue(v13, unit, robloxLocaleId, v10)
			v18 = v13 > 0
		end
	end

	local v19 = {
		layoutOrder = data.layoutOrder,
		plotId = metric.id,
		series = dataPoints ~= nil and {
			{ id = metric.id, name = title, points = dataPoints }
		} or nil,
		hasData = data.hasData,
		title = title,
		summary = data.summary,
		valueText = v14,
		icon = 0,
		deltaText = 0,
		isDeltaPositive = 0,
		yAxisFormatter = 0,
		xAxisFormatter = 0,
		tooltipFormatters = 0
	}

	local v20 = if not data.hideIcon then metric.chartIcon or metric.icon else nil
	v19.icon = v20
	v19.deltaText = v17
	v19.isDeltaPositive = v18
	function v19.yAxisFormatter(p2)
		return formatMetricValue(scaleValueToUnit(p2.value, unit), unit, robloxLocaleId, v10)
	end

	function v19.xAxisFormatter(p2)
		return formatMetricTimestamp(p2.value, v12, v9)
	end

	v19.tooltipFormatters = {
		formatXForPoint = function(p2)
			return formatMetricTimestamp(p2, v12, v9)
		end,
		formatSeriesValueForPoint = function(p2)
			return formatMetricValue(scaleValueToUnit(p2.y, unit), unit, robloxLocaleId, v10, "Full")
		end
	}
	return v19
end

return useMetricChartContent
