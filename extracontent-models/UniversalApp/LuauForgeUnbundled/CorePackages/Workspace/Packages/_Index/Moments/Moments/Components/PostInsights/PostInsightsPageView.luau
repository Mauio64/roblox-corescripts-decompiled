local AnalyticsMetricChart = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/AnalyticsMetricChart")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/FocusNavigationUtils")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/InputHandlers")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactFocusNavigation")
local FFlagMomentsUseSharedReactions = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsUseSharedReactions")

local headerBar = Foundation.HeaderBar
local icon = Foundation.Icon
local scrollView = Foundation.ScrollView
local skeleton = Foundation.Skeleton
local text = Foundation.Text
local view = Foundation.View
local iconName = Foundation.Enums.IconName
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useTokens = Foundation.Hooks.useTokens

local focusRoot = FocusNavigationUtils.FocusRoot
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local momentMediaTile = MomentsCommon.Media.MomentMediaTile

local v5 = if FFlagMomentsUseSharedReactions then require("@game/CorePackages/Workspace/Packages/_Index/Moments/Reactions/Reaction") else MomentsCommon.Components.Reaction
local reactionAssets = MomentsCommon.Components.ReactionAssets
local reactionSize = MomentsCommon.Enums.ReactionSize
local formFactor = MomentsCommon.Enums.FormFactor
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useFormFactor = MomentsCommon.Hooks.useFormFactor

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Constants")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/usePostInsightsPageViewModel")

local vector2 = Vector2.new(83, 124)

local vector2_2 = Vector2.new(94, 140)

local udim = UDim2.fromOffset(64, 24)

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local frozen = table.freeze({ ZIndex = Constants.DisplayOrder.Modals })

local function noop() end

local function Thumbnail(props)
	local v6 = useTokens()
	local createElement = React.createElement
	local v8 = {
		LayoutOrder = props.LayoutOrder,
		cornerRadius = UDim.new(0, v6.Radius.Small),
		Size = UDim2.fromOffset(props.size.X, props.size.Y),
		tag = "radius-small clip bg-surface-300",
		testId = "post-insights-thumbnail"
	}

	local v10 = if props.mediaItem ~= nil then React.createElement(momentMediaTile, {
		mediaItem = props.mediaItem,
		isActive = false
	}) else nil
	return createElement(view, v8, { Media = v10 })
end

local function InteractionCounts(props)
	local v6 = useTokens()
	local children = {}

	for k, interactionCount in props.interactionCounts do
		local key = interactionCount.key
		local createElement = React.createElement

		local v9 = if not props.isWide then UDim2.fromOffset(52, 0) else nil
		children[key] = createElement(view, {
			LayoutOrder = k,
			Size = v9,
			tag = {
				["col align-x-center gap-xsmall padding-y-small"] = true,
				["auto-xy"] = props.isWide,
				["auto-y"] = not props.isWide
			}
		}, {
			Icon = React.createElement(icon, {
				LayoutOrder = 1,
				name = interactionCount.icon,
				size = v6.Size.Size_600,
				style = v6.Color.Content.Emphasis
			}),
			Count = React.createElement(text, {
				LayoutOrder = 2,
				Text = interactionCount.countText,
				tag = "auto-xy text-label-small content-emphasis",
				testId = `post-insights-count-{interactionCount.key}`
			})
		})
	end

	return React.createElement(view, {
		LayoutOrder = props.LayoutOrder,
		tag = {
			row = true,
			["gap-xxlarge auto-xy"] = props.isWide,
			["align-x-center gap-small size-full-0 auto-y"] = not props.isWide
		}
	}, children)
end

local function Summary(props)
	local viewProps = props.viewProps

	if not props.isWide then
		return React.createElement(
			view,
			{
				LayoutOrder = props.LayoutOrder,
				tag = "col align-x-center gap-xlarge size-full-0 auto-y"
			},
			{
				Thumbnail = React.createElement(Thumbnail, {
					LayoutOrder = 1,
					mediaItem = viewProps.mediaItem,
					size = vector2
				}),
				Counts = React.createElement(InteractionCounts, {
					LayoutOrder = 2,
					interactionCounts = viewProps.interactionCounts,
					isWide = false
				})
			}
		)
	end

	local createElement = React.createElement
	local v7 = {
		LayoutOrder = props.LayoutOrder,
		tag = "row align-y-center gap-xxlarge size-full-0 auto-y"
	}

	local v8 = {
		Thumbnail = React.createElement(Thumbnail, {
			LayoutOrder = 1,
			mediaItem = viewProps.mediaItem,
			size = vector2_2
		}),
		Details = 0
	}

	local createElement2 = React.createElement
	local v12

	if not (viewProps.caption == nil and viewProps.postedOnText == nil) then
		local createElement3 = React.createElement

		local v16 = if viewProps.caption ~= nil then React.createElement(text, {
			LayoutOrder = 1,
			Text = viewProps.caption,
			tag = "size-full-0 auto-y text-heading-small text-align-x-left text-truncate-end content-emphasis",
			testId = "post-insights-caption"
		}) else nil

		local v17 = if viewProps.postedOnText ~= nil then React.createElement(text, {
			LayoutOrder = 2,
			Text = viewProps.postedOnText,
			tag = "size-full-0 auto-y text-body-medium text-align-x-left content-default",
			testId = "post-insights-posted-on"
		}) else nil
		v12 = createElement3(
			view,
			{
				LayoutOrder = 1,
				tag = "col align-x-left gap-xsmall size-full-0 auto-y",
				testId = "post-insights-summary-text"
			},
			{ Caption = v16, PostedOn = v17 }
		)
	end

	v8.Details = createElement2(
		view,
		{ LayoutOrder = 2, tag = "col align-x-left fill gap-medium auto-y" },
		{
			Text = v12,
			Counts = React.createElement(InteractionCounts, {
				LayoutOrder = 2,
				interactionCounts = viewProps.interactionCounts,
				isWide = true
			})
		}
	)
	return createElement(view, v7, v8)
end

local function SectionHeading(p2)
	return React.createElement(text, {
		LayoutOrder = p2.LayoutOrder,
		Text = p2.text,
		tag = "auto-xy text-heading-small content-emphasis"
	})
end

local function Metric(props)
	local createElement = React.createElement
	local v7 = { LayoutOrder = props.LayoutOrder, tag = props.tag }
	local v8 = {
		Label = React.createElement(text, {
			LayoutOrder = 1,
			Text = props.label,
			tag = "auto-xy text-body-medium content-default",
			testId = `{props.testId}-label`
		}),
		Value = 0
	}

	local v9 = if props.isLoading then React.createElement(skeleton, {
		LayoutOrder = 2,
		Size = udim,
		testId = `{props.testId}-skeleton`
	}) else React.createElement(text, {
		LayoutOrder = 2,
		Text = props.valueText,
		tag = "auto-xy text-heading-small content-emphasis",
		testId = props.testId
	})
	v8.Value = v9
	return createElement(view, v7, v8)
end

local function ViewsChartSkeleton(p2)
	return React.createElement(
		view,
		{
			LayoutOrder = p2.LayoutOrder,
			tag = "col gap-small size-full-0 auto-y",
			testId = "post-insights-views-chart-skeleton"
		},
		{
			Title = React.createElement(skeleton, {
				LayoutOrder = 1,
				Size = UDim2.new(0.4, 0, 0, 22)
			}),
			Value = React.createElement(skeleton, {
				LayoutOrder = 2,
				Size = UDim2.new(0.25, 0, 0, 32)
			}),
			Plot = React.createElement(skeleton, {
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, AnalyticsMetricChart.chartLayout.PLOT_HEIGHT)
			})
		}
	)
end

local function OverviewSection(props)
	local clone = table.clone(props.viewsChart)
	clone.layoutOrder = 2
	local children = {
		Heading = React.createElement(SectionHeading, {
			LayoutOrder = 1,
			text = props.heading
		}),
		ViewsChart = 0
	}
	local v6

	if props.isViewsChartLoading then
		v6 = React.createElement(ViewsChartSkeleton, { LayoutOrder = 2 })
	elseif props.isViewsChartVisible then
		v6 = React.createElement(view, {
			LayoutOrder = 2,
			tag = "col gap-large size-full-0 auto-y"
		}, {
			TotalViews = React.createElement(Metric, {
				LayoutOrder = 1,
				label = props.totalViewsLabel,
				valueText = props.totalViewsText,
				isLoading = props.isTotalViewsLoading,
				tag = "col gap-xxsmall auto-xy",
				testId = "post-insights-total-views"
			}),
			Chart = React.createElement(AnalyticsMetricChart.MetricChart, clone)
		})
	end

	children.ViewsChart = v6

	for i = 1, math.ceil(#props.overviewMetrics / 2) do
		local children2 = {}

		for j = 1, 2 do
			local overviewMetric = props.overviewMetrics[(i - 1) * 2 + j]

			if overviewMetric ~= nil then
				children2[overviewMetric.key] = React.createElement(Metric, {
					LayoutOrder = j,
					label = overviewMetric.label,
					valueText = overviewMetric.valueText,
					isLoading = overviewMetric.isLoading,
					tag = "col fill gap-xxsmall auto-y padding-y-small",
					testId = `post-insights-metric-{overviewMetric.key}`
				})
			end
		end

		children[`Row{i}`] = React.createElement(view, {
			LayoutOrder = i + 2,
			tag = "row gap-medium size-full-0 auto-y"
		}, children2)
	end

	return React.createElement(
		view,
		{
			LayoutOrder = props.LayoutOrder,
			tag = "col gap-medium size-full-0 auto-y padding-y-xsmall"
		},
		children
	)
end

local function EngagementSection(p2)
	local v6 = useTokens()
	local v7

	if FFlagMomentsUseSharedReactions then
		v7 = v6.Size.Size_600
	else
		v7 = assert(
			reactionAssets.getSizePixels(reactionSize.Small),
			"expected a pixel size for Small reactions"
		)
	end

	local children = {}

	for k, reactionCount in p2.viewProps.reactionCounts do
		children[reactionCount.reactionType] = React.createElement(view, {
			LayoutOrder = k,
			sizeConstraint = { MinSize = Vector2.new(v7, 0) },
			tag = "col align-x-center gap-xxsmall auto-xy",
			testId = `post-insights-reaction-item-{reactionCount.reactionType}`
		}, {
			Reaction = React.createElement(v5, {
				LayoutOrder = 1,
				reactionType = reactionCount.reactionType,
				size = reactionSize.Small
			}),
			Count = React.createElement(text, {
				LayoutOrder = 2,
				Text = reactionCount.countText,
				tag = "auto-xy text-caption-medium content-emphasis",
				testId = `post-insights-reaction-{reactionCount.reactionType}`
			})
		})
	end

	return React.createElement(
		view,
		{
			LayoutOrder = p2.LayoutOrder,
			tag = "col gap-large size-full-0 auto-y padding-y-xsmall"
		},
		{
			Heading = React.createElement(SectionHeading, {
				LayoutOrder = 1,
				text = p2.viewProps.engagementHeading
			}),
			Card = React.createElement(
				view,
				{
					LayoutOrder = 2,
					tag = "col gap-large size-full-0 auto-y padding-y-xsmall",
					testId = "post-insights-engagement-card"
				},
				{
					Total = React.createElement(Metric, {
						LayoutOrder = 1,
						label = p2.viewProps.totalReactionsLabel,
						valueText = p2.viewProps.totalReactionsText,
						tag = "col gap-xxsmall auto-xy",
						testId = "post-insights-total-reactions"
					}),
					Reactions = React.createElement(view, {
						LayoutOrder = 2,
						sizeConstraint = { MaxSize = Vector2.new(353, 1e999) },
						tag = "row flex-x-between size-full-0 auto-y"
					}, children)
				}
			)
		}
	)
end

local function PostInsightsPageView(props)
	local v6 = useDeviceInsets()
	local v7 = useFormFactor() == formFactor.Wide

	local onBack = props.onBack
	local v8 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					onBack()
					object:cancel()
				end)
			}
		}
	end, { onBack })

	return React.createElement(focusRoot, {
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.CentralOverlay,
		isAutoFocusRoot = true,
		eventMap = navigateBacks,
		eventHandlers = v8,
		frameProps = frozen
	}, {
		InputSink = React.createElement(view, {
			onActivated = noop,
			stateLayer = { affordance = stateLayerAffordance.None },
			tag = "size-full",
			ZIndex = 1
		}),
		Page = React.createElement(
			view,
			{
				tag = "col size-full bg-surface-0",
				testId = "post-insights-page",
				ZIndex = 2
			},
			{
				Header = React.createElement(view, {
					LayoutOrder = 1,
					padding = {
						top = UDim.new(0, v6.top),
						left = UDim.new(0, v6.left),
						right = UDim.new(0, v6.right)
					},
					tag = "size-full-0 auto-y"
				}, {
					HeaderBar = React.createElement(
						headerBar.Root,
						{ hasBackground = false, testId = "post-insights-header" },
						{
							Leading = React.createElement(headerBar.Leading, nil, {
								Actions = React.createElement(headerBar.Actions, {
									actions = {
										{
											id = "back",
											icon = iconName.ChevronLargeLeft,
											onActivated = props.onBack
										}
									}
								}),
								Title = React.createElement(text, {
									LayoutOrder = 1,
									Text = props.title,
									tag = "auto-xy text-heading-medium text-truncate-end content-emphasis"
								})
							})
						}
					)
				}),
				Body = React.createElement(scrollView, {
					LayoutOrder = 2,
					scroll = {
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						CanvasSize = UDim2.new(),
						ScrollingDirection = Enum.ScrollingDirection.Y
					},
					tag = "fill size-full-0"
				}, {
					Centering = React.createElement(view, {
						padding = {
							bottom = UDim.new(0, v6.bottom),
							left = UDim.new(0, v6.left),
							right = UDim.new(0, v6.right)
						},
						tag = "col align-x-center size-full-0 auto-y"
					}, {
						Content = React.createElement(view, {
							sizeConstraint = { MaxSize = Vector2.new(608, 1e999) },
							tag = "col gap-xlarge size-full-0 auto-y padding-xlarge"
						}, {
							Summary = React.createElement(Summary, {
								LayoutOrder = 1,
								viewProps = props,
								isWide = v7
							}),
							Overview = React.createElement(OverviewSection, {
								LayoutOrder = 2,
								heading = props.overviewHeading,
								totalViewsLabel = props.totalViewsLabel,
								totalViewsText = props.totalViewsText,
								isTotalViewsLoading = props.isTotalViewsLoading,
								viewsChart = props.viewsChart,
								isViewsChartLoading = props.isViewsChartLoading,
								isViewsChartVisible = props.isViewsChartVisible,
								overviewMetrics = props.overviewMetrics
							}),
							Engagement = React.createElement(EngagementSection, {
								LayoutOrder = 3,
								viewProps = props
							})
						})
					})
				})
			}
		)
	})
end

return PostInsightsPageView
