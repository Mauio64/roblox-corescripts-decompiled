local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")

local button = Foundation.Button
local iconButton = Foundation.IconButton
local text = Foundation.Text
local view = Foundation.View
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize
local fillBehavior = Foundation.Enums.FillBehavior
local iconName = Foundation.Enums.IconName
local FFlagBuildAnalyticsGoals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAnalyticsGoals")
local sheet = Foundation.Sheet
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsMetric")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsWindow")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAnalytics")
local MetricChartContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Chart/MetricChartContainer")

local function MetricDetailSheetView(props)
	local testId = props.testId or "MetricDetailSheetView"
	local navigation = if FFlagBuildAnalyticsGoals then props.navigation else nil
	local v5

	if FFlagBuildAnalyticsGoals and props.improvementText ~= nil and props.improvementText ~= "" then
		v5 = React.createElement(
			view,
			{
				LayoutOrder = 3,
				tag = "col gap-small size-full-0 auto-y",
				testId = `{testId}.HowToImprove`
			},
			{
				Title = React.createElement(text, {
					LayoutOrder = 1,
					Text = props.improvementTitleText,
					tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-left content-emphasis",
					testId = `{testId}.HowToImproveTitle`
				}),
				Tips = React.createElement(text, {
					LayoutOrder = 2,
					Text = props.improvementText,
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-muted",
					testId = `{testId}.ImprovementText`
				})
			}
		)
	end

	local v6 = {
		[navigation == nil and "Chart" or `Chart{navigation.index}`] = React.createElement(MetricChartContainer, {
			universeId = props.universeId,
			metric = props.metric,
			window = props.window,
			latestAvailableTime = props.latestAvailableTime,
			metadataStatus = props.metadataStatus,
			hideIcon = true,
			summary = props.summaryText
		})
	}

	local createElement = React.createElement
	local root = sheet.Root
	local v7 = {
		ref = props.focusRootRef,
		isOpen = true,
		onClose = props.onClose,
		testId = testId
	}

	local children = {
		Header = React.createElement(sheet.Header, {
			hasCloseAffordance = props.showCloseButton ~= false
		}, {
			Title = React.createElement(text, {
				Text = props.titleText,
				tag = "shrink auto-xy text-heading-small text-wrap text-align-x-left content-emphasis",
				testId = `{testId}.Title`
			})
		}),
		Content = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local content = sheet.Content
	local createElement3 = React.createElement

	local v12 = if navigation ~= nil and navigation.count > 1 then React.createElement(
		view,
		{
			LayoutOrder = 0,
			tag = "row align-x-right gap-small size-full-0 auto-y",
			testId = `{testId}.Navigation`
		},
		{
			Previous = React.createElement(iconButton, {
				LayoutOrder = 1,
				icon = iconName.ChevronLargeLeft,
				size = inputSize.Small,
				onActivated = navigation.onPrevious,
				isDisabled = navigation.index == 1,
				testId = `{testId}.Previous`
			}),
			Next = React.createElement(iconButton, {
				LayoutOrder = 2,
				icon = iconName.ChevronLargeRight,
				size = inputSize.Small,
				onActivated = navigation.onNext,
				isDisabled = navigation.index == navigation.count,
				testId = `{testId}.Next`
			})
		}
	) else nil
	children.Content = createElement2(content, nil, {
		Body = createElement3(view, {
			tag = "col gap-large size-full-0 auto-y padding-top-medium"
		}, {
			Navigation = v12,
			ChartCard = React.createElement(
				view,
				{
					LayoutOrder = 1,
					tag = "col size-full-0 auto-y padding-large stroke-standard stroke-default radius-large",
					testId = `{testId}.ChartCard`
				},
				v6
			),
			Description = React.createElement(text, {
				LayoutOrder = 2,
				Text = props.descriptionText,
				tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-muted",
				testId = `{testId}.Description`
			}),
			HowToImprove = v5
		})
	})

	children.Actions = React.createElement(sheet.Actions, nil, {
		Analyze = React.createElement(button, {
			LayoutOrder = 1,
			text = props.analyzeText,
			size = inputSize.Medium,
			variant = buttonVariant.Emphasis,
			fillBehavior = fillBehavior.Fill,
			width = UDim.new(1, 0),
			isDisabled = props.isAnalyzeDisabled,
			onActivated = props.onAnalyze,
			testId = `{testId}.Analyze`
		}),
		ViewInOverview = React.createElement(button, {
			LayoutOrder = 2,
			text = props.viewInOverviewText,
			icon = iconName.ArrowUpRightFromSquare,
			size = inputSize.Medium,
			variant = buttonVariant.Standard,
			fillBehavior = fillBehavior.Fill,
			width = UDim.new(1, 0),
			onActivated = props.onViewInOverview,
			testId = `{testId}.ViewInOverview`
		})
	})
	return createElement(root, v7, children)
end

return MetricDetailSheetView
