local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local View = Foundation.View
local Text = Foundation.Text
local Skeleton = Foundation.Skeleton
local Radius = Foundation.Enums.Radius

local AnalyticsKeys = require(BuildExperience.Analytics.AnalyticsKeys)
local CreatorAnalytics = require(parent.DataHydration.CreatorAnalytics)
local DataStatus = CreatorAnalytics.DataStatus
require(BuildExperience.Analytics.AnalyticsMetric)
require(BuildExperience.Analytics.AnalyticsWindow)
local useExperienceMetricSeries = require(BuildExperience.Analytics.useExperienceMetricSeries)
local FFlagBuildAnalyticsCreatorHubWindowFix = require(BuildExperience.Flags.FFlagBuildAnalyticsCreatorHubWindowFix)
local MetricChart = require(script.Parent.MetricChart)
local AnalyticsMetricChart = require(parent.AnalyticsMetricChart)
local PLOT_HEIGHT = AnalyticsMetricChart.chartLayout.PLOT_HEIGHT

local function MetricChartSkeleton(p)
	return React.createElement(
		View,
		{
			LayoutOrder = p.layoutOrder,
			tag = "col gap-xsmall size-full-0 auto-y",
			testId = "MetricChart.Skeleton"
		},
		{
			Title = React.createElement(Skeleton, {
				LayoutOrder = 1,
				radius = Radius.Small,
				Size = UDim2.new(0.4, 0, 0, 22)
			}),
			Summary = React.createElement(Skeleton, {
				LayoutOrder = 2,
				radius = Radius.Small,
				Size = UDim2.new(0.6, 0, 0, 16)
			}),
			Value = React.createElement(Skeleton, {
				LayoutOrder = 3,
				radius = Radius.Small,
				Size = UDim2.new(0.25, 0, 0, 32)
			}),
			Plot = React.createElement(Skeleton, {
				LayoutOrder = 4,
				radius = Radius.Medium,
				Size = UDim2.new(1, 0, 0, PLOT_HEIGHT)
			})
		}
	)
end

local function MetricChartEmpty(p)
	return React.createElement(
		View,
		{
			LayoutOrder = p.layoutOrder,
			tag = "col gap-xsmall size-full-0 auto-y",
			testId = "MetricChart.Empty"
		},
		{
			Message = React.createElement(Text, {
				Text = p.message,
				tag = "size-full-0 auto-y text-body-medium text-align-x-left content-muted"
			})
		}
	)
end

local function MetricChartContainer(props)
	local latestAvailableTime

	if props.metadataStatus ~= DataStatus.Failed then
		latestAvailableTime = props.latestAvailableTime
	end

	local v = useExperienceMetricSeries(props.universeId, props.metric, props.window, latestAvailableTime)

	local noData = useLocalization({ noData = AnalyticsKeys.ANALYTICS_NO_DATA }).noData
	local v2

	if props.metadataStatus == DataStatus.Failed then
		v2 = true
	elseif props.metadataStatus == DataStatus.Ready then
		v2 = props.latestAvailableTime == nil
	else
		v2 = false
	end

	if v2 then
		return React.createElement(MetricChartEmpty, {
			layoutOrder = props.layoutOrder,
			message = noData
		})
	end

	if v.status == DataStatus.NotReady then
		return React.createElement(MetricChartSkeleton, { layoutOrder = props.layoutOrder })
	end

	local v3

	if FFlagBuildAnalyticsCreatorHubWindowFix then
		v3 = not v.hasData
	else
		v3 = v.status == DataStatus.Failed or not v.hasData
	end

	if v3 then
		return React.createElement(MetricChartEmpty, {
			layoutOrder = props.layoutOrder,
			message = noData
		})
	end

	return React.createElement(MetricChart, {
		series = v.series,
		hasData = v.hasData,
		latest = v.latest,
		trendPct = v.trendPct,
		priorValue = v.priorValue,
		metric = props.metric,
		window = props.window,
		latestAvailableTime = latestAvailableTime,
		hideIcon = props.hideIcon,
		summary = props.summary,
		layoutOrder = props.layoutOrder
	})
end

return MetricChartContainer
