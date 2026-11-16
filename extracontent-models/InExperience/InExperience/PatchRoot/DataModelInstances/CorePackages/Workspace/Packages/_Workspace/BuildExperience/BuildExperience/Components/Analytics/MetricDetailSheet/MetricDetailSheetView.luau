local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Button = Foundation.Button
local IconButton = Foundation.IconButton
local Text = Foundation.Text
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local FillBehavior = Foundation.Enums.FillBehavior
local IconName = Foundation.Enums.IconName
local FFlagBuildAnalyticsGoals = require(BuildExperience.Flags.FFlagBuildAnalyticsGoals)
local Sheet = Foundation.Sheet
require(BuildExperience.Analytics.AnalyticsMetric)
require(BuildExperience.Analytics.AnalyticsWindow)
require(parent.DataHydration.CreatorAnalytics)
local MetricChartContainer = require(BuildExperience.Components.Analytics.Chart.MetricChartContainer)

local function MetricDetailSheetView(props)
	local testId = props.testId or "MetricDetailSheetView"
	local navigation

	if FFlagBuildAnalyticsGoals then
		navigation = props.navigation
	end

	local howToImprove

	if FFlagBuildAnalyticsGoals and props.improvementText ~= nil and props.improvementText ~= "" then
		howToImprove = React.createElement(
			View,
			{
				LayoutOrder = 3,
				tag = "col gap-small size-full-0 auto-y",
				testId = `{testId}.HowToImprove`
			},
			{
				Title = React.createElement(Text, {
					LayoutOrder = 1,
					Text = props.improvementTitleText,
					tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-left content-emphasis",
					testId = `{testId}.HowToImproveTitle`
				}),
				Tips = React.createElement(Text, {
					LayoutOrder = 2,
					Text = props.improvementText,
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-muted",
					testId = `{testId}.ImprovementText`
				})
			}
		)
	end

	local v = {
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
	local root = Sheet.Root
	local v2 = { ref = props.focusRootRef, isOpen = true, onClose = props.onClose, testId = testId }

	local children = {
		Header = React.createElement(Sheet.Header, {
			hasCloseAffordance = props.showCloseButton ~= false
		}, {
			Title = React.createElement(Text, {
				Text = props.titleText,
				tag = "shrink auto-xy text-heading-small text-wrap text-align-x-left content-emphasis",
				testId = `{testId}.Title`
			})
		}),
		Content = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local content = Sheet.Content
	local createElement3 = React.createElement
	local navigation2

	if not (navigation == nil or not (navigation.count > 1)) then
		navigation2 = React.createElement(
			View,
			{
				LayoutOrder = 0,
				tag = "row align-x-right gap-small size-full-0 auto-y",
				testId = `{testId}.Navigation`
			},
			{
				Previous = React.createElement(IconButton, {
					LayoutOrder = 1,
					icon = IconName.ChevronLargeLeft,
					size = InputSize.Small,
					onActivated = navigation.onPrevious,
					isDisabled = navigation.index == 1,
					testId = `{testId}.Previous`
				}),
				Next = React.createElement(IconButton, {
					LayoutOrder = 2,
					icon = IconName.ChevronLargeRight,
					size = InputSize.Small,
					onActivated = navigation.onNext,
					isDisabled = navigation.index == navigation.count,
					testId = `{testId}.Next`
				})
			}
		)
	end

	children.Content = createElement2(content, nil, {
		Body = createElement3(View, { tag = "col gap-large size-full-0 auto-y padding-top-medium" }, {
			Navigation = navigation2,
			ChartCard = React.createElement(
				View,
				{
					LayoutOrder = 1,
					tag = "col size-full-0 auto-y padding-large stroke-standard stroke-default radius-large",
					testId = `{testId}.ChartCard`
				},
				v
			),
			Description = React.createElement(Text, {
				LayoutOrder = 2,
				Text = props.descriptionText,
				tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-muted",
				testId = `{testId}.Description`
			}),
			HowToImprove = howToImprove
		})
	})

	children.Actions = React.createElement(Sheet.Actions, nil, {
		Analyze = React.createElement(Button, {
			LayoutOrder = 1,
			text = props.analyzeText,
			size = InputSize.Medium,
			variant = ButtonVariant.Emphasis,
			fillBehavior = FillBehavior.Fill,
			width = UDim.new(1, 0),
			isDisabled = props.isAnalyzeDisabled,
			onActivated = props.onAnalyze,
			testId = `{testId}.Analyze`
		}),
		ViewInOverview = React.createElement(Button, {
			LayoutOrder = 2,
			text = props.viewInOverviewText,
			icon = IconName.ArrowUpRightFromSquare,
			size = InputSize.Medium,
			variant = ButtonVariant.Standard,
			fillBehavior = FillBehavior.Fill,
			width = UDim.new(1, 0),
			onActivated = props.onViewInOverview,
			testId = `{testId}.ViewInOverview`
		})
	})
	return createElement(root, v2, children)
end

return MetricDetailSheetView
