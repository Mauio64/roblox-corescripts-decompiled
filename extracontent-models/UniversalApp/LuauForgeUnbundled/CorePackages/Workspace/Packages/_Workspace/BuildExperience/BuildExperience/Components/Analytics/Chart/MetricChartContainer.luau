local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization

local view = Foundation.View
local text = Foundation.Text
local skeleton = Foundation.Skeleton
local radius = Foundation.Enums.Radius

local AnalyticsKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsKeys")
local dataStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAnalytics").DataStatus
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsMetric")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsWindow")
local useExperienceMetricSeries = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/useExperienceMetricSeries")
local FFlagBuildAnalyticsCreatorHubWindowFix = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAnalyticsCreatorHubWindowFix")
local MetricChart = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Chart/MetricChart")
local PLOT_HEIGHT = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/AnalyticsMetricChart").chartLayout.PLOT_HEIGHT

local function MetricChartSkeleton(p2)
	return React.createElement(
		view,
		{
			LayoutOrder = p2.layoutOrder,
			tag = "col gap-xsmall size-full-0 auto-y",
			testId = "MetricChart.Skeleton"
		},
		{
			Title = React.createElement(skeleton, {
				LayoutOrder = 1,
				radius = radius.Small,
				Size = UDim2.new(0.4, 0, 0, 22)
			}),
			Summary = React.createElement(skeleton, {
				LayoutOrder = 2,
				radius = radius.Small,
				Size = UDim2.new(0.6, 0, 0, 16)
			}),
			Value = React.createElement(skeleton, {
				LayoutOrder = 3,
				radius = radius.Small,
				Size = UDim2.new(0.25, 0, 0, 32)
			}),
			Plot = React.createElement(skeleton, {
				LayoutOrder = 4,
				radius = radius.Medium,
				Size = UDim2.new(1, 0, 0, PLOT_HEIGHT)
			})
		}
	)
end

local function MetricChartEmpty(p2)
	return React.createElement(
		view,
		{
			LayoutOrder = p2.layoutOrder,
			tag = "col gap-xsmall size-full-0 auto-y",
			testId = "MetricChart.Empty"
		},
		{
			Message = React.createElement(text, {
				Text = p2.message,
				tag = "size-full-0 auto-y text-body-medium text-align-x-left content-muted"
			})
		}
	)
end

local function MetricChartContainer(props)
	local latestAvailableTime = if props.metadataStatus ~= dataStatus.Failed then props.latestAvailableTime else nil
	local v5 = useExperienceMetricSeries(props.universeId, props.metric, props.window, latestAvailableTime)

	local noData = useLocalization({ noData = AnalyticsKeys.ANALYTICS_NO_DATA }).noData
	local v6

	if props.metadataStatus == dataStatus.Failed then
		v6 = true
	else
		v6 = props.metadataStatus == dataStatus.Ready and props.latestAvailableTime == nil
	end

	if v6 then
		return React.createElement(MetricChartEmpty, {
			layoutOrder = props.layoutOrder,
			message = noData
		})
	end

	if v5.status == dataStatus.NotReady then
		return React.createElement(MetricChartSkeleton, {
			layoutOrder = props.layoutOrder
		})
	end

	local v7 = if FFlagBuildAnalyticsCreatorHubWindowFix then not v5.hasData else v5.status == dataStatus.Failed or not v5.hasData

	if v7 then
		return React.createElement(MetricChartEmpty, {
			layoutOrder = props.layoutOrder,
			message = noData
		})
	end

	return React.createElement(MetricChart, {
		series = v5.series,
		hasData = v5.hasData,
		latest = v5.latest,
		trendPct = v5.trendPct,
		priorValue = v5.priorValue,
		metric = props.metric,
		window = props.window,
		latestAvailableTime = latestAvailableTime,
		hideIcon = props.hideIcon,
		summary = props.summary,
		layoutOrder = props.layoutOrder
	})
end

return MetricChartContainer
