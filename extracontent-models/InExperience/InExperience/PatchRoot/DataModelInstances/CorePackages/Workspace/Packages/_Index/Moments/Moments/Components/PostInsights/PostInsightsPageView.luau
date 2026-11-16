local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local AnalyticsMetricChart = require(parent.AnalyticsMetricChart)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Foundation = require(parent.Foundation)
local InputHandlers = require(parent.InputHandlers)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
require(parent.ReactFocusNavigation)
local FFlagMomentsUseSharedReactions = require(Moments.Flags.FFlagMomentsUseSharedReactions)

local HeaderBar = Foundation.HeaderBar
local Icon = Foundation.Icon
local ScrollView = Foundation.ScrollView
local Skeleton = Foundation.Skeleton
local Text = Foundation.Text
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useTokens = Foundation.Hooks.useTokens

local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local MomentMediaTile = MomentsCommon.Media.MomentMediaTile
local v

if FFlagMomentsUseSharedReactions then
	v = require(parent.Reactions.Reaction)
else
	v = MomentsCommon.Components.Reaction
end

local ReactionSize = MomentsCommon.Enums.ReactionSize
local FormFactor = MomentsCommon.Enums.FormFactor
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useFormFactor = MomentsCommon.Hooks.useFormFactor

local Constants = require(Moments.Constants)
require(script.Parent.usePostInsightsPageViewModel)

local vector2 = Vector2.new(83, 124)

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local frozen = table.freeze({ ZIndex = Constants.DisplayOrder.Modals })

local function noop() end

local function Thumbnail(p)
	local v2 = useTokens()
	local createElement = React.createElement
	local v3 = {
		LayoutOrder = p.LayoutOrder,
		cornerRadius = UDim.new(0, v2.Radius.Small),
		Size = UDim2.fromOffset(vector2.X, vector2.Y),
		tag = "radius-small clip bg-surface-300",
		testId = "post-insights-thumbnail"
	}
	local media

	if p.mediaItem ~= nil then
		media = React.createElement(MomentMediaTile, { mediaItem = p.mediaItem, isActive = false })
	end

	return createElement(View, v3, { Media = media })
end

local function InteractionCounts(props)
	local v2 = useTokens()
	local children = {}

	for k, interactionCount in props.interactionCounts do
		children[interactionCount.key] = React.createElement(
			View,
			{
				LayoutOrder = k,
				Size = UDim2.fromOffset(52, 0),
				tag = "col align-x-center gap-xsmall auto-y padding-y-small"
			},
			{
				Icon = React.createElement(Icon, {
					LayoutOrder = 1,
					name = interactionCount.icon,
					size = v2.Size.Size_600,
					style = v2.Color.Content.Emphasis
				}),
				Count = React.createElement(Text, {
					LayoutOrder = 2,
					Text = interactionCount.countText,
					tag = "auto-xy text-label-small content-emphasis",
					testId = `post-insights-count-{interactionCount.key}`
				})
			}
		)
	end

	return React.createElement(View, {
		LayoutOrder = props.LayoutOrder,
		tag = {
			["row gap-small"] = true,
			["auto-xy"] = props.isWide,
			["align-x-center size-full-0 auto-y"] = not props.isWide
		}
	}, children)
end

local function Summary(props)
	local viewProps = props.viewProps

	if not props.isWide then
		return React.createElement(
			View,
			{
				LayoutOrder = props.LayoutOrder,
				tag = "col align-x-center gap-xlarge size-full-0 auto-y"
			},
			{
				Thumbnail = React.createElement(Thumbnail, {
					LayoutOrder = 1,
					mediaItem = viewProps.mediaItem
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
	local v2 = {
		LayoutOrder = props.LayoutOrder,
		tag = "row align-y-center gap-large size-full-0 auto-y"
	}

	local v3 = {
		Thumbnail = React.createElement(Thumbnail, {
			LayoutOrder = 1,
			mediaItem = viewProps.mediaItem
		}),
		Details = 0
	}

	local createElement2 = React.createElement
	local caption

	if viewProps.caption ~= nil then
		caption = React.createElement(Text, {
			LayoutOrder = 1,
			Text = viewProps.caption,
			tag = "size-full-0 auto-y text-title-large text-align-x-left text-truncate-end content-emphasis",
			testId = "post-insights-caption"
		})
	end

	v3.Details = createElement2(View, { LayoutOrder = 2, tag = "col fill gap-small auto-y" }, {
		Caption = caption,
		Counts = React.createElement(InteractionCounts, {
			LayoutOrder = 2,
			interactionCounts = viewProps.interactionCounts,
			isWide = true
		})
	})
	return createElement(View, v2, v3)
end

local function SectionHeading(p)
	return React.createElement(Text, {
		LayoutOrder = p.LayoutOrder,
		Text = p.text,
		tag = "auto-xy text-heading-small content-emphasis"
	})
end

local function Metric(props)
	return React.createElement(
		View,
		{
			LayoutOrder = props.LayoutOrder,
			tag = "col fill gap-xxsmall auto-y padding-x-xsmall padding-y-small"
		},
		{
			Label = React.createElement(Text, {
				LayoutOrder = 1,
				Text = props.label,
				tag = "auto-xy text-body-medium content-default"
			}),
			Value = React.createElement(Text, {
				LayoutOrder = 2,
				Text = props.valueText,
				tag = "auto-xy text-heading-small content-emphasis",
				testId = props.testId
			})
		}
	)
end

local function ViewsChartSkeleton(p)
	return React.createElement(
		View,
		{
			LayoutOrder = p.LayoutOrder,
			tag = "col gap-small size-full-0 auto-y",
			testId = "post-insights-views-chart-skeleton"
		},
		{
			Title = React.createElement(Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.new(0.4, 0, 0, 22)
			}),
			Value = React.createElement(Skeleton, {
				LayoutOrder = 2,
				Size = UDim2.new(0.25, 0, 0, 32)
			}),
			Plot = React.createElement(Skeleton, {
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
		Heading = React.createElement(SectionHeading, { LayoutOrder = 1, text = props.heading }),
		ViewsChart = 0
	}
	local viewsChart

	if props.isViewsChartLoading then
		viewsChart = React.createElement(ViewsChartSkeleton, { LayoutOrder = 2 })
	else
		viewsChart = React.createElement(AnalyticsMetricChart.MetricChart, clone)
	end

	children.ViewsChart = viewsChart

	for i = 1, math.ceil(#props.overviewMetrics / 2) do
		local children2 = {}

		for j = 1, 2 do
			local overviewMetric = props.overviewMetrics[(i - 1) * 2 + j]

			if overviewMetric ~= nil then
				children2[overviewMetric.key] = React.createElement(Metric, {
					LayoutOrder = j,
					label = overviewMetric.label,
					valueText = overviewMetric.valueText,
					testId = `post-insights-metric-{overviewMetric.key}`
				})
			end
		end

		children[`Row{i}`] = React.createElement(View, {
			LayoutOrder = i + 2,
			tag = "row gap-medium size-full-0 auto-y"
		}, children2)
	end

	return React.createElement(
		View,
		{
			LayoutOrder = props.LayoutOrder,
			tag = "col gap-medium size-full-0 auto-y padding-y-xsmall"
		},
		children
	)
end

local function EngagementSection(p)
	local children = {}

	for k, reactionCount in p.viewProps.reactionCounts do
		children[reactionCount.reactionType] = React.createElement(
			View,
			{
				LayoutOrder = k,
				Size = UDim2.fromOffset(38, 0),
				tag = "col align-x-center gap-xxsmall auto-y"
			},
			{
				Reaction = React.createElement(v, {
					LayoutOrder = 1,
					reactionType = reactionCount.reactionType,
					size = ReactionSize.Small
				}),
				Count = React.createElement(Text, {
					LayoutOrder = 2,
					Text = reactionCount.countText,
					tag = "auto-xy text-caption-medium content-emphasis",
					testId = `post-insights-reaction-{reactionCount.reactionType}`
				})
			}
		)
	end

	return React.createElement(
		View,
		{ LayoutOrder = p.LayoutOrder, tag = "col gap-large size-full-0 auto-y padding-y-xsmall" },
		{
			Heading = React.createElement(SectionHeading, {
				LayoutOrder = 1,
				text = p.viewProps.engagementHeading
			}),
			Card = React.createElement(
				View,
				{ LayoutOrder = 2, tag = "col gap-large size-full-0 auto-y padding-xsmall" },
				{
					Total = React.createElement(View, {
						LayoutOrder = 1,
						tag = "col gap-xsmall auto-xy"
					}, {
						Label = React.createElement(Text, {
							LayoutOrder = 1,
							Text = p.viewProps.totalReactionsLabel,
							tag = "auto-xy text-label-medium content-muted"
						}),
						Value = React.createElement(Text, {
							LayoutOrder = 2,
							Text = p.viewProps.totalReactionsText,
							tag = "auto-xy text-heading-small content-emphasis",
							testId = "post-insights-total-reactions"
						})
					}),
					Reactions = React.createElement(View, {
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
	local v2 = useDeviceInsets()
	local isWide = useFormFactor() == FormFactor.Wide

	local onBack = props.onBack
	local eventHandlers = React.useMemo(function()
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					onBack()
					object:cancel()
				end)
			}
		}
	end, { onBack })

	return React.createElement(FocusRoot, {
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
		isAutoFocusRoot = true,
		eventMap = navigateBacks,
		eventHandlers = eventHandlers,
		frameProps = frozen
	}, {
		InputSink = React.createElement(View, {
			onActivated = noop,
			stateLayer = { affordance = StateLayerAffordance.None },
			tag = "size-full",
			ZIndex = 1
		}),
		Page = React.createElement(
			View,
			{ tag = "col size-full bg-surface-0", testId = "post-insights-page", ZIndex = 2 },
			{
				Header = React.createElement(View, {
					LayoutOrder = 1,
					padding = {
						top = UDim.new(0, v2.top),
						left = UDim.new(0, v2.left),
						right = UDim.new(0, v2.right)
					},
					tag = "size-full-0 auto-y"
				}, {
					HeaderBar = React.createElement(
						HeaderBar.Root,
						{ hasBackground = false, testId = "post-insights-header" },
						{
							Leading = React.createElement(HeaderBar.Leading, nil, {
								Actions = React.createElement(HeaderBar.Actions, {
									actions = {
										{
											id = "back",
											icon = IconName.ChevronLargeLeft,
											onActivated = props.onBack
										}
									}
								}),
								Title = React.createElement(Text, {
									LayoutOrder = 1,
									Text = props.title,
									tag = "auto-xy text-heading-medium text-truncate-end content-emphasis"
								})
							})
						}
					)
				}),
				Body = React.createElement(ScrollView, {
					LayoutOrder = 2,
					scroll = {
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						CanvasSize = UDim2.new(),
						ScrollingDirection = Enum.ScrollingDirection.Y
					},
					tag = "fill size-full-0"
				}, {
					Centering = React.createElement(View, {
						padding = {
							bottom = UDim.new(0, v2.bottom),
							left = UDim.new(0, v2.left),
							right = UDim.new(0, v2.right)
						},
						tag = "col align-x-center size-full-0 auto-y"
					}, {
						Content = React.createElement(View, {
							sizeConstraint = { MaxSize = Vector2.new(608, 1e999) },
							tag = "col gap-xlarge size-full-0 auto-y padding-xlarge"
						}, {
							Summary = React.createElement(Summary, {
								LayoutOrder = 1,
								viewProps = props,
								isWide = isWide
							}),
							Overview = React.createElement(OverviewSection, {
								LayoutOrder = 2,
								heading = props.overviewHeading,
								viewsChart = props.viewsChart,
								isViewsChartLoading = props.isViewsChartLoading,
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
