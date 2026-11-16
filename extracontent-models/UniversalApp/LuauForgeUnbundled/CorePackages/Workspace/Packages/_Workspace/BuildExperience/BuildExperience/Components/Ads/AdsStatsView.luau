local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/StatsCard/StatsCard")
local StatsCardContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/StatsCardContainer")
local PastCampaignsList = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/PastCampaignsList")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/PastCampaignRow")
local CreateAdCampaignSheetContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/CreateAdCampaignSheet/CreateAdCampaignSheetContainer")
local FFlagBuildAdsManagerUniverseUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAdsManagerUniverseUrl")

local icon = Foundation.Icon
local text = Foundation.Text
local view = Foundation.View
local skeleton = Foundation.Skeleton

local iconName = Foundation.Enums.IconName
local radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local function renderActiveCampaign(activeCampaign, k, testId)
	local formatted = `{testId}-active-{k}`
	return React.createElement(
		view,
		{
			LayoutOrder = k,
			tag = "col gap-medium size-full-0 auto-y",
			testId = formatted
		},
		{
			DateRange = React.createElement(text, {
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

local function renderSkeletonTileRow(p2, size_1600)
	local children = {}

	for i = 1, 2 do
		children[`Cell{i}`] = React.createElement(view, {
			LayoutOrder = i,
			tag = "fill auto-y"
		}, {
			Card = React.createElement(skeleton, {
				Size = UDim2.new(1, 0, 0, size_1600),
				radius = radius.Large
			})
		})
	end

	return React.createElement(
		view,
		{ LayoutOrder = p2, tag = "row gap-medium size-full-0 auto-y" },
		children
	)
end

local function LoadingSkeleton(p2)
	local v5 = useTokens()
	local size_400 = v5.Size.Size_400
	local size_1600 = v5.Size.Size_1600
	local size_2000 = v5.Size.Size_2000

	return React.createElement(
		view,
		{
			LayoutOrder = p2.layoutOrder,
			tag = "col gap-xlarge size-full-0 auto-y padding-top-xlarge",
			testId = p2.testId
		},
		{
			ActiveBlock = React.createElement(
				view,
				{ LayoutOrder = 1, tag = "col gap-medium size-full-0 auto-y" },
				{
					DateRange = React.createElement(skeleton, {
						LayoutOrder = 1,
						Size = UDim2.new(0.4, 0, 0, size_400),
						radius = radius.Small
					}),
					Grid = React.createElement(
						view,
						{ LayoutOrder = 2, tag = "col gap-medium size-full-0 auto-y" },
						{
							Row1 = renderSkeletonTileRow(1, size_1600),
							Row2 = renderSkeletonTileRow(2, size_1600)
						}
					)
				}
			),
			PastSection = React.createElement(
				view,
				{ LayoutOrder = 2, tag = "col gap-small size-full-0 auto-y" },
				{
					Heading = React.createElement(skeleton, {
						LayoutOrder = 1,
						Size = UDim2.new(0.35, 0, 0, size_400),
						radius = radius.Small
					}),
					Rows = React.createElement(
						view,
						{ LayoutOrder = 2, tag = "col gap-small size-full-0 auto-y" },
						{
							Row1 = React.createElement(skeleton, {
								LayoutOrder = 1,
								Size = UDim2.new(1, 0, 0, size_2000),
								radius = radius.Large
							}),
							Row2 = React.createElement(skeleton, {
								LayoutOrder = 2,
								Size = UDim2.new(1, 0, 0, size_2000),
								radius = radius.Large
							})
						}
					)
				}
			)
		}
	)
end

local function EmptyState(props)
	local v5 = useTokens()
	local size_1400 = v5.Size.Size_1400

	return React.createElement(
		view,
		{
			LayoutOrder = 1,
			tag = "col align-x-center gap-small size-full-0 auto-y",
			testId = `{props.testId}-empty`
		},
		{
			Illustration = React.createElement(icon, {
				LayoutOrder = 1,
				name = iconName.ChartScatterPlot,
				size = size_1400,
				style = v5.Color.Content.Emphasis,
				testId = `{props.testId}-empty-illustration`
			}),
			Headings = React.createElement(
				view,
				{
					LayoutOrder = 2,
					tag = "col align-x-center gap-xxsmall size-full-0 auto-y"
				},
				{
					Title = React.createElement(text, {
						LayoutOrder = 1,
						Text = props.title,
						tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-center content-emphasis"
					}),
					Subtitle = React.createElement(text, {
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
	local v7 = if FFlagBuildAdsManagerUniverseUrl then props.universeId else nil
	local children = {}

	children.PromotionSheet = createElement(CreateAdCampaignSheetContainer, {
		universeId = v7,
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
		children.Error = React.createElement(text, {
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
			local v8 = {}

			for k, activeCampaign in props.activeCampaigns do
				v8[activeCampaign.id] = renderActiveCampaign(activeCampaign, k, testId)
			end

			children.ActiveCampaigns = React.createElement(
				view,
				{
					LayoutOrder = 1,
					tag = "col gap-large size-full-0 auto-y",
					testId = `{testId}-active-campaigns`
				},
				v8
			)
		end

		if #props.pastCampaigns > 0 then
			children.PastCampaigns = React.createElement(
				view,
				{
					LayoutOrder = 2,
					tag = "col gap-small size-full-0 auto-y",
					testId = `{testId}-past-campaigns`
				},
				{
					Heading = React.createElement(text, {
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

	local v8 = not (props.isFailed or props.isLoading or props.hasCampaigns)
	return React.createElement(view, {
		LayoutOrder = props.layoutOrder,
		tag = {
			["col align-y-center size-full"] = v8,
			["col gap-xlarge size-full-0 auto-y padding-top-xlarge"] = not v8
		},
		testId = testId
	}, children)
end

return AdsStatsView
