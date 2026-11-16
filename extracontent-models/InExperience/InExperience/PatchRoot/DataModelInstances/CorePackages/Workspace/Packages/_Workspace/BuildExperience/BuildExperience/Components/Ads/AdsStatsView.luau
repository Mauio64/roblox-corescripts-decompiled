local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
require(parent.DataHydration.CreatorAgentChat)

require(BuildExperience.Components.Analytics.StatsCard.StatsCard)
local StatsCardContainer = require(BuildExperience.Components.Analytics.StatsCardContainer)
local PastCampaignsList = require(script.Parent.PastCampaignsList)
require(script.Parent.PastCampaignRow)
local CreateAdCampaignSheetContainer = require(script.Parent.CreateAdCampaignSheet.CreateAdCampaignSheetContainer)
local FFlagBuildAdsManagerUniverseUrl = require(BuildExperience.Flags.FFlagBuildAdsManagerUniverseUrl)

local Icon = Foundation.Icon
local Text = Foundation.Text
local View = Foundation.View
local Skeleton = Foundation.Skeleton

local IconName = Foundation.Enums.IconName
local Radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local function renderActiveCampaign(activeCampaign, k: number, testId: string)
	local formatted = `{testId}-active-{k}`
	return React.createElement(
		View,
		{ LayoutOrder = k, tag = "col gap-medium size-full-0 auto-y", testId = formatted },
		{
			DateRange = React.createElement(Text, {
				LayoutOrder = 1,
				Text = activeCampaign.dateText,
				tag = "size-full-0 auto-y text-title-medium text-align-x-left content-emphasis",
				testId = `{formatted}-date-range`
			}),
			Cards = React.createElement(StatsCardContainer, {
				layoutOrder = 2,
				cards = activeCampaign.summaryCards,
				testId = `{formatted}-cards`
			})
		}
	)
end

local function renderSkeletonTileRow(layoutOrder: number, size_1600: number)
	local children = {}

	for i = 1, 2 do
		children[`Cell{i}`] = React.createElement(View, { LayoutOrder = i, tag = "fill auto-y" }, {
			Card = React.createElement(Skeleton, {
				Size = UDim2.new(1, 0, 0, size_1600),
				radius = Radius.Large
			})
		})
	end

	return React.createElement(View, {
		LayoutOrder = layoutOrder,
		tag = "row gap-medium size-full-0 auto-y"
	}, children)
end

local function LoadingSkeleton(p)
	local v = useTokens()
	local size_400 = v.Size.Size_400
	local size_1600 = v.Size.Size_1600
	local size_2000 = v.Size.Size_2000

	return React.createElement(
		View,
		{
			LayoutOrder = p.layoutOrder,
			tag = "col gap-xlarge size-full-0 auto-y padding-top-xlarge",
			testId = p.testId
		},
		{
			ActiveBlock = React.createElement(View, {
				LayoutOrder = 1,
				tag = "col gap-medium size-full-0 auto-y"
			}, {
				DateRange = React.createElement(Skeleton, {
					LayoutOrder = 1,
					Size = UDim2.new(0.4, 0, 0, size_400),
					radius = Radius.Small
				}),
				Grid = React.createElement(View, {
					LayoutOrder = 2,
					tag = "col gap-medium size-full-0 auto-y"
				}, {
					Row1 = renderSkeletonTileRow(1, size_1600),
					Row2 = renderSkeletonTileRow(2, size_1600)
				})
			}),
			PastSection = React.createElement(View, {
				LayoutOrder = 2,
				tag = "col gap-small size-full-0 auto-y"
			}, {
				Heading = React.createElement(Skeleton, {
					LayoutOrder = 1,
					Size = UDim2.new(0.35, 0, 0, size_400),
					radius = Radius.Small
				}),
				Rows = React.createElement(View, {
					LayoutOrder = 2,
					tag = "col gap-small size-full-0 auto-y"
				}, {
					Row1 = React.createElement(Skeleton, {
						LayoutOrder = 1,
						Size = UDim2.new(1, 0, 0, size_2000),
						radius = Radius.Large
					}),
					Row2 = React.createElement(Skeleton, {
						LayoutOrder = 2,
						Size = UDim2.new(1, 0, 0, size_2000),
						radius = Radius.Large
					})
				})
			})
		}
	)
end

local function EmptyState(props)
	local v = useTokens()
	local size_1400 = v.Size.Size_1400

	return React.createElement(
		View,
		{
			LayoutOrder = 1,
			tag = "col align-x-center gap-small size-full-0 auto-y",
			testId = `{props.testId}-empty`
		},
		{
			Illustration = React.createElement(Icon, {
				LayoutOrder = 1,
				name = IconName.ChartScatterPlot,
				size = size_1400,
				style = v.Color.Content.Emphasis,
				testId = `{props.testId}-empty-illustration`
			}),
			Headings = React.createElement(
				View,
				{ LayoutOrder = 2, tag = "col align-x-center gap-xxsmall size-full-0 auto-y" },
				{
					Title = React.createElement(Text, {
						LayoutOrder = 1,
						Text = props.title,
						tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-center content-emphasis"
					}),
					Subtitle = React.createElement(Text, {
						LayoutOrder = 2,
						Text = props.subtitle,
						tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-center content-default"
					})
				}
			)
		}
	)
end

local function AdsStatsView(props)
	local testId = props.testId or "AdsStatsView"

	local createElement = React.createElement
	local universeId

	if FFlagBuildAdsManagerUniverseUrl then
		universeId = props.universeId
	end

	local children = {}

	children.PromotionSheet = createElement(CreateAdCampaignSheetContainer, {
		universeId = universeId,
		isOpen = props.isPromotionSheetOpen,
		onClose = props.onClosePromotionSheet,
		onCreate = props.onCreateCampaign,
		waitForCreateResult = true,
		isCreatePending = props.isPromotionCreatePending,
		hasCreateError = props.hasPromotionCreateError,
		createErrorKind = props.promotionCreateErrorKind,
		useLocalRunDates = true,
		campaignDurationDays = props.adCampaignDurationDays,
		estimatedPriceRobux = props.adCampaignEstimatedPriceRobux,
		campaignOffers = props.adCampaignOffers,
		runStartTimeMs = props.adCampaignRunStartTimeMs,
		runEndTimeMs = props.adCampaignRunEndTimeMs
	})

	if props.isFailed then
		children.Error = React.createElement(Text, {
			LayoutOrder = 1,
			Text = props.errorText,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
			testId = `{testId}-error`
		})
	elseif props.isLoading then
		children.Loading = React.createElement(LoadingSkeleton, {
			layoutOrder = 1,
			testId = `{testId}-loading`
		})
	elseif props.hasCampaigns then
		if #props.activeCampaigns > 0 then
			local v = {}

			for k, activeCampaign in props.activeCampaigns do
				v[activeCampaign.id] = renderActiveCampaign(activeCampaign, k, testId)
			end

			children.ActiveCampaigns = React.createElement(
				View,
				{
					LayoutOrder = 1,
					tag = "col gap-large size-full-0 auto-y",
					testId = `{testId}-active-campaigns`
				},
				v
			)
		end

		if #props.pastCampaigns > 0 then
			children.PastCampaigns = React.createElement(
				View,
				{
					LayoutOrder = 2,
					tag = "col gap-small size-full-0 auto-y",
					testId = `{testId}-past-campaigns`
				},
				{
					Heading = React.createElement(Text, {
						LayoutOrder = 1,
						Text = props.pastCampaignsTitle,
						tag = "size-full-0 auto-y text-title-medium text-align-x-left content-emphasis"
					}),
					List = React.createElement(PastCampaignsList, {
						layoutOrder = 2,
						rows = props.pastCampaigns
					})
				}
			)
		end
	else
		children.EmptyState = React.createElement(EmptyState, {
			title = props.emptyTitle,
			subtitle = props.emptySubtitle,
			testId = testId
		})
	end

	local colalignycentersizefull = not (props.isFailed or props.isLoading or props.hasCampaigns)
	return React.createElement(View, {
		LayoutOrder = props.layoutOrder,
		tag = {
			["col align-y-center size-full"] = colalignycentersizefull,
			["col gap-xlarge size-full-0 auto-y padding-top-xlarge"] = not colalignycentersizefull
		},
		testId = testId
	}, children)
end

return AdsStatsView
