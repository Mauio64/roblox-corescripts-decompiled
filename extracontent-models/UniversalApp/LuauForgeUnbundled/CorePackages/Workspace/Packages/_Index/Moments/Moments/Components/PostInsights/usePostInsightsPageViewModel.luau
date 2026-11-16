local LocalizationService = game:GetService("LocalizationService")

require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/AnalyticsMetricChart")
local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local MomentsTypes = require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local abbreviateCount = Localization.abbreviateCount
local numberLocalization = Localization.NumberLocalization
local useLocalization = Localization.Hooks.useLocalization
local useSignalState = SignalsReact.useSignalState
local useTokens = Foundation.Hooks.useTokens
local reactionType = MomentsTypes.Enums.ReactionType

local CreatorAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/CreatorAnalytics")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/createPostInsightsPageStore")
local postInsightsStrings = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/postInsightsStrings")
local usePostInsightsAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/usePostInsightsAnalytics")
local toMediaItem = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Media/toMediaItem")

local dataStatus = CreatorAnalytics.DataStatus

local function getPlayableSeconds(p2)
	local trim = if p2.edits ~= nil then p2.edits.trim else nil

	if trim ~= nil and trim.endTime > trim.startTime then
		return trim.endTime - trim.startTime
	end

	local assetTotalDuration = p2.assetTotalDuration

	if assetTotalDuration == nil or not (assetTotalDuration > 0) then
		return nil
	end

	return assetTotalDuration
end

local function percentKey(p2, p3)
	return {
		postInsightsStrings.PERCENT_KEY,
		number = numberLocalization.localize(math.round(p2 * 1000) / 10, p3)
	}
end

local v5 = {
	reactionType.ThumbsUp,
	reactionType.Heart,
	reactionType.LaughJoy,
	reactionType.Wow,
	reactionType.Cry,
	reactionType.Fire,
	reactionType.Skull
}

local function usePostInsightsPageViewModel(p2, onBack)
	local v6 = useTokens()
	local v7 = useLocalization(postInsightsStrings.PAGE_KEYS)
	local moment = p2.moment
	local momentStore = p2.momentStore

	local v8 = useSignalState(momentStore.getReactionCount)
	local v9 = useSignalState(momentStore.getIndividualReactionCounts)
	local v10 = useSignalState(momentStore.getCommentCount)
	local v11 = useSignalState(momentStore.getShareCount)

	local v12 = React.useMemo(function()
		local v13 = toMediaItem({ kind = "moment", moment = moment })

		if v13 ~= nil then
			v13.cornerRadius = v6.Radius.Small
		end

		return v13
	end, { moment.momentId })

	local v13 = React.useMemo(function()
		local countsByReaction = {}

		for k, v14 in v9 do
			countsByReaction[v14.reaction] = v14.count
		end

		local result = {}

		for k, v14 in v5 do
			table.insert(result, {
				reactionType = v14,
				countText = abbreviateCount(countsByReaction[v14] or 0, LocalizationService.RobloxLocaleId)
			})
		end

		return result
	end, { v9 })

	local v14 = usePostInsightsAnalytics(moment)
	local robloxLocaleId = LocalizationService.RobloxLocaleId

	local v15 = v14.lifetimeViews
	local v16 = nil
	local v17 = nil
	local v18 = nil

	if v15 ~= nil and v15 > 0 then
		if v14.lifetimeWatchTimeSeconds ~= nil then
			local v19 = v14.lifetimeWatchTimeSeconds / v15
			v16 = math.round(v19)
			local metadata = moment.metadata
			local trim = if metadata.edits ~= nil then metadata.edits.trim else nil
			local v20

			if trim == nil or not (trim.endTime > trim.startTime) then
				v20 = metadata.assetTotalDuration

				if v20 == nil or not (v20 > 0) then
					v20 = nil
				end
			else
				v20 = trim.endTime - trim.startTime
			end

			if v20 ~= nil then
				v17 = math.min(v19 / v20, 1)
			end
		end

		if v14.lifetimeJoins ~= nil then
			v18 = v14.lifetimeJoins / v15
		end
	end

	local v20 = useLocalization((React.useMemo(function()
		return {
			averageWatchTime = {
				postInsightsStrings.DURATION_SECONDS_KEY,
				seconds = v16 or 0
			},
			averageCompletion = {
				postInsightsStrings.PERCENT_KEY,
				number = numberLocalization.localize((math.round)((v17 or 0) * 1000) / 10, robloxLocaleId)
			},
			gameJoinConversion = {
				postInsightsStrings.PERCENT_KEY,
				number = numberLocalization.localize((math.round)((v18 or 0) * 1000) / 10, robloxLocaleId)
			}
		}
	end, {
		v16 or false,
		v17 or false,
		v18 or false,
		robloxLocaleId
	})))

	local v21 = {
		{
			key = "averageWatchTime",
			label = v7.averageWatchTime,
			valueText = v16 == nil and "—" or v20.averageWatchTime
		},
		{
			key = "averageCompletion",
			label = v7.averageCompletion,
			valueText = v17 == nil and "—" or v20.averageCompletion
		},
		{
			key = "gameJoinConversion",
			label = v7.gameJoinConversion,
			valueText = v18 == nil and "—" or v20.gameJoinConversion
		}
	}

	local viewsSeries = v14.viewsSeries

	local v22 = not (v14.window == nil) and v14.window.granularity == CreatorAnalytics.MetricGranularity.OneHour
	local function formatTime(p3)
		local dateTime = DateTime.fromIsoDate(p3)

		if dateTime == nil then
			return p3
		end

		if v22 then
			return (dateTime:FormatLocalTime("LT", robloxLocaleId))
		end

		return (dateTime:FormatUniversalTime("MMM D", robloxLocaleId))
	end

	if v15 == nil then
		v15 = if viewsSeries ~= nil then viewsSeries.total else nil
	end

	local v23 = {
		plotId = `views:{moment.momentId}`,
		series = viewsSeries ~= nil and {
			{ id = "views", name = v7.totalViews, points = viewsSeries.points }
		} or nil,
		hasData = viewsSeries ~= nil and viewsSeries.hasData,
		title = v7.totalViews,
		valueText = v15 == nil and "—" or abbreviateCount(v15, robloxLocaleId),
		isDeltaPositive = false,
		yAxisFormatter = function(p3)
			return abbreviateCount(p3.value, robloxLocaleId)
		end,
		xAxisFormatter = function(p3)
			local value = p3.value
			local dateTime = DateTime.fromIsoDate(value)

			if dateTime == nil then
				return value
			end

			if v22 then
				return (dateTime:FormatLocalTime("LT", robloxLocaleId))
			end

			return (dateTime:FormatUniversalTime("MMM D", robloxLocaleId))
		end,
		tooltipFormatters = {
			formatXForPoint = formatTime,
			formatSeriesValueForPoint = function(p3)
				return numberLocalization.localize(p3.y, robloxLocaleId)
			end
		},
		testId = "post-insights-views-chart"
	}

	local description = moment.metadata.description
	local v25 = {
		title = v7.title,
		overviewHeading = v7.overview,
		engagementHeading = v7.engagement,
		totalReactionsLabel = v7.totalReactions,
		onBack = onBack,
		mediaItem = v12,
		caption = 0,
		interactionCounts = 0,
		viewsChart = 0,
		isViewsChartLoading = 0,
		overviewMetrics = 0,
		totalReactionsText = 0,
		reactionCounts = 0
	}

	if description == nil or description == "" then
		description = nil
	end

	v25.caption = description
	v25.interactionCounts = {
		{
			key = "likes",
			icon = BuilderIcons.Icon.ThumbUp,
			countText = abbreviateCount(v8 or 0, LocalizationService.RobloxLocaleId)
		},
		{
			key = "comments",
			icon = BuilderIcons.Icon.SpeechBubbleAlignLeft,
			countText = abbreviateCount(v10 or 0, LocalizationService.RobloxLocaleId)
		},
		{
			key = "shares",
			icon = BuilderIcons.Icon.ArrowThickToRight,
			countText = abbreviateCount(v11 or 0, LocalizationService.RobloxLocaleId)
		}
	}

	v25.viewsChart = v23
	v25.isViewsChartLoading = v14.viewsStatus == dataStatus.NotReady
	v25.overviewMetrics = v21
	v25.totalReactionsText = abbreviateCount(v8 or 0, LocalizationService.RobloxLocaleId)
	v25.reactionCounts = v13
	return v25
end

return usePostInsightsPageViewModel
