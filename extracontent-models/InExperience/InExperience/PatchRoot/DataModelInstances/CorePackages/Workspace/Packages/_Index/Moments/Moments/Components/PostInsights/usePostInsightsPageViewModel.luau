local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local LocalizationService = game:GetService("LocalizationService")

require(parent.AnalyticsMetricChart)
local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
require(parent.MomentsCommon)
local MomentsTypes = require(parent.MomentsTypes)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local abbreviateCount = Localization.abbreviateCount
local NumberLocalization = Localization.NumberLocalization
local useLocalization = Localization.Hooks.useLocalization
local useSignalState = SignalsReact.useSignalState
local useTokens = Foundation.Hooks.useTokens
local ReactionType = MomentsTypes.Enums.ReactionType

local CreatorAnalytics = require(parent.DataHydration.CreatorAnalytics)

require(script.Parent.createPostInsightsPageStore)
local postInsightsStrings = require(script.Parent.postInsightsStrings)
local usePostInsightsAnalytics = require(script.Parent.usePostInsightsAnalytics)
local toMediaItem = require(Moments.Components.Feed.Media.toMediaItem)

local DataStatus = CreatorAnalytics.DataStatus

local function getPlayableSeconds(metadata) -- 1 equivalent call inferred from this helper
	local trim

	if metadata.edits ~= nil then
		trim = metadata.edits.trim
	end

	if trim ~= nil and trim.endTime > trim.startTime then
		return trim.endTime - trim.startTime
	end

	local assetTotalDuration = metadata.assetTotalDuration

	if assetTotalDuration == nil or not (assetTotalDuration > 0) then
		return nil
	end

	return assetTotalDuration
end

local function percentKey(p: number, robloxLocaleId: string) -- 2 equivalent calls inferred from this helper
	return {
		postInsightsStrings.PERCENT_KEY,
		number = NumberLocalization.localize(math.round(p * 1000) / 10, robloxLocaleId)
	}
end

local v = {
	ReactionType.ThumbsUp,
	ReactionType.Heart,
	ReactionType.LaughJoy,
	ReactionType.Wow,
	ReactionType.Cry,
	ReactionType.Fire,
	ReactionType.Skull
}

local function usePostInsightsPageViewModel(p, onBack)
	local v2 = useTokens()
	local v3 = useLocalization(postInsightsStrings.PAGE_KEYS)
	local moment = p.moment
	local momentStore = p.momentStore

	local v4 = useSignalState(momentStore.getReactionCount)
	local v5 = useSignalState(momentStore.getIndividualReactionCounts)
	local v6 = useSignalState(momentStore.getCommentCount)
	local v7 = useSignalState(momentStore.getShareCount)

	local mediaItem = React.useMemo(function()
		local v8 = toMediaItem({ kind = "moment", moment = moment })

		if v8 ~= nil then
			v8.cornerRadius = v2.Radius.Small
		end

		return v8
	end, { moment.momentId })

	local reactionCounts = React.useMemo(function()
		local countsByReaction = {}

		for _, v8 in v5 do
			countsByReaction[v8.reaction] = v8.count
		end

		local result = {}

		for _, reactionType in v do
			table.insert(result, {
				reactionType = reactionType,
				countText = abbreviateCount(countsByReaction[reactionType] or 0, LocalizationService.RobloxLocaleId)
			})
		end

		return result
	end, { v5 })

	local v8 = usePostInsightsAnalytics(moment)
	local robloxLocaleId = LocalizationService.RobloxLocaleId

	local v9 = v8.lifetimeViews
	local v10 = nil
	local v11 = nil
	local v12 = nil

	if v9 ~= nil and v9 > 0 then
		if v8.lifetimeWatchTimeSeconds ~= nil then
			local v13 = v8.lifetimeWatchTimeSeconds / v9
			v10 = math.round(v13)
			local playableSeconds = getPlayableSeconds(moment.metadata) -- inferred equivalent call

			if playableSeconds ~= nil then
				v11 = math.min(v13 / playableSeconds, 1)
			end
		end

		if v8.lifetimeJoins ~= nil then
			v12 = v8.lifetimeJoins / v9
		end
	end

	local v13 = useLocalization((React.useMemo(function()
		return {
			averageWatchTime = {
				postInsightsStrings.DURATION_SECONDS_KEY,
				seconds = v10 or 0
			},
			averageCompletion = percentKey(v11 or 0, robloxLocaleId), -- inferred equivalent call
			gameJoinConversion = percentKey(v12 or 0, robloxLocaleId) -- inferred equivalent call
		}
	end, {
		v10 or false,
		v11 or false,
		v12 or false,
		robloxLocaleId
	})))

	local overviewMetrics = {
		{
			key = "averageWatchTime",
			label = v3.averageWatchTime,
			valueText = v10 == nil and "—" or v13.averageWatchTime
		},
		{
			key = "averageCompletion",
			label = v3.averageCompletion,
			valueText = v11 == nil and "—" or v13.averageCompletion
		},
		{
			key = "gameJoinConversion",
			label = v3.gameJoinConversion,
			valueText = v12 == nil and "—" or v13.gameJoinConversion
		}
	}

	local viewsSeries = v8.viewsSeries
	local v14

	if v8.window == nil then
		v14 = false
	else
		v14 = v8.window.granularity == CreatorAnalytics.MetricGranularity.OneHour
	end

	local function formatTime(value: string) -- 1 equivalent call inferred from this helper
		local dateTime = DateTime.fromIsoDate(value)

		if dateTime == nil then
			return value
		end

		if v14 then
			return (dateTime:FormatLocalTime("LT", robloxLocaleId))
		end

		return (dateTime:FormatUniversalTime("MMM D", robloxLocaleId))
	end

	if v9 == nil then
		v9 = if viewsSeries ~= nil then viewsSeries.total else nil
	end

	local viewsChart = {
		plotId = `views:{moment.momentId}`,
		series = viewsSeries ~= nil and {
			{ id = "views", name = v3.totalViews, points = viewsSeries.points }
		} or nil,
		hasData = viewsSeries ~= nil and viewsSeries.hasData,
		title = v3.totalViews,
		valueText = v9 == nil and "—" or abbreviateCount(v9, robloxLocaleId),
		isDeltaPositive = false,
		yAxisFormatter = function(p2)
			return abbreviateCount(p2.value, robloxLocaleId)
		end,
		xAxisFormatter = function(p2)
			return formatTime(p2.value) -- inferred equivalent call
		end,
		tooltipFormatters = {
			formatXForPoint = formatTime,
			formatSeriesValueForPoint = function(p2)
				return NumberLocalization.localize(p2.y, robloxLocaleId)
			end
		},
		testId = "post-insights-views-chart"
	}

	local description = moment.metadata.description
	local v15 = {
		title = v3.title,
		overviewHeading = v3.overview,
		engagementHeading = v3.engagement,
		totalReactionsLabel = v3.totalReactions,
		onBack = onBack,
		mediaItem = mediaItem,
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

	v15.caption = description
	v15.interactionCounts = {
		{
			key = "likes",
			icon = BuilderIcons.Icon.ThumbUp,
			countText = abbreviateCount(v4 or 0, LocalizationService.RobloxLocaleId)
		},
		{
			key = "comments",
			icon = BuilderIcons.Icon.SpeechBubbleAlignLeft,
			countText = abbreviateCount(v6 or 0, LocalizationService.RobloxLocaleId)
		},
		{
			key = "shares",
			icon = BuilderIcons.Icon.ArrowThickToRight,
			countText = abbreviateCount(v7 or 0, LocalizationService.RobloxLocaleId)
		}
	}

	v15.viewsChart = viewsChart
	v15.isViewsChartLoading = v8.viewsStatus == DataStatus.NotReady
	v15.overviewMetrics = overviewMetrics
	v15.totalReactionsText = abbreviateCount(v4 or 0, LocalizationService.RobloxLocaleId)
	v15.reactionCounts = reactionCounts
	return v15
end

return usePostInsightsPageViewModel
