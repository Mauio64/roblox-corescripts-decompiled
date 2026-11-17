local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local LocalizationService = game:GetService("LocalizationService")

require(parent.AnalyticsMetricChart)
local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local MomentsCommon = require(parent.MomentsCommon)
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
local makeFeedActionFields = require(Moments.Analytics.makeFeedActionFields)
local postInsightsStrings = require(script.Parent.postInsightsStrings)
local usePostInsightsAnalytics = require(script.Parent.usePostInsightsAnalytics)
local toMediaItem = require(Moments.Components.Feed.Media.toMediaItem)

local DataStatus = CreatorAnalytics.DataStatus
local EventNames = MomentsCommon.Analytics.EventNames

local function isAwaitingQueries(items) -- 3 equivalent calls inferred from this helper
	local v = false

	for _, item in items do
		if item == DataStatus.Failed then
			return false
		end

		if item == DataStatus.NotReady then
			v = true
		end
	end

	return v
end

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

local function usePostInsightsPageViewModel(p, callback)
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

	local function logPageEvent(postInsightsBackButtonPressed, p2: string, p3: number?) -- 1 equivalent call inferred from this helper
		local recommendationMetadata = moment.recommendationMetadata

		local momentId = moment.momentId
		local feedItemId

		if recommendationMetadata ~= nil then
			feedItemId = recommendationMetadata.feedItemId
		end

		local v9

		if recommendationMetadata ~= nil then
			v9 = recommendationMetadata.tracingId
		end

		local feedActionFields = makeFeedActionFields(momentId, feedItemId, v9, p2)

		if feedActionFields ~= nil then
			if p3 ~= nil then
				feedActionFields.durationMs = tostring(p3)
			end

			MomentsCommon.Analytics.fireAnalyticsEvent(postInsightsBackButtonPressed, feedActionFields)
		end
	end

	local v9

	if v8.viewsStatus == DataStatus.NotReady then
		v9 = false
	else
		v9 = v8.lifetimeStatus ~= DataStatus.NotReady
	end

	local ref = React.useRef(false)
	React.useEffect(function()
		if not v9 or ref.current then
			return
		end

		ref.current = true
		local postInsightsPageImpression = EventNames.PostInsightsPageImpression
		local recommendationMetadata = moment.recommendationMetadata

		local momentId = moment.momentId
		local feedItemId

		if recommendationMetadata ~= nil then
			feedItemId = recommendationMetadata.feedItemId
		end

		local v10

		if recommendationMetadata ~= nil then
			v10 = recommendationMetadata.tracingId
		end

		local feedActionFields = makeFeedActionFields(momentId, feedItemId, v10, "post_insights_impression")

		if feedActionFields ~= nil then
			MomentsCommon.Analytics.fireAnalyticsEvent(postInsightsPageImpression, feedActionFields)
		end
	end, { v9 })

	local ref2 = React.useRef(os.clock())

	local onBack = React.useCallback(function()
		local v10 = math.round((os.clock() - ref2.current) * 1000)
		logPageEvent(EventNames.PostInsightsBackButtonPressed, "post_insights_back", v10) -- inferred equivalent call
		callback()
	end, { callback, moment })

	local lifetimeViews = v8.lifetimeViews
	local v10 = nil
	local v11 = nil
	local v12 = nil

	if lifetimeViews ~= nil and lifetimeViews > 0 then
		if v8.lifetimeWatchTimeSeconds ~= nil then
			v10 = math.round(v8.lifetimeWatchTimeSeconds / lifetimeViews)
		end

		local playableSeconds = getPlayableSeconds(moment.metadata) -- inferred equivalent call

		if v8.lifetimeWatchTimeNoReplaySeconds ~= nil and playableSeconds ~= nil then
			v11 = math.min(v8.lifetimeWatchTimeNoReplaySeconds / lifetimeViews / playableSeconds, 1)
		end

		if v8.lifetimeJoins ~= nil then
			v12 = v8.lifetimeJoins / lifetimeViews
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
	local dateTime

	if moment.createdAt ~= nil then
		dateTime = DateTime.fromIsoDate(moment.createdAt)
	end

	local v14

	if dateTime == nil then
		v14 = nil
	else
		v14 = dateTime:FormatLocalTime("L", robloxLocaleId)
	end

	local v15 = useLocalization((React.useMemo(function()
		return {
			postedOn = {
				postInsightsStrings.POSTED_ON_DATE_KEY,
				date = v14 or ""
			}
		}
	end, { v14 or false })))

	local awaitingQueries = isAwaitingQueries({ v8.lifetimeViewsStatus, v8.lifetimeWatchTimeStatus }) -- inferred equivalent call

	local awaitingQueries2 = isAwaitingQueries({ v8.lifetimeViewsStatus, v8.lifetimeWatchTimeNoReplayStatus }) -- inferred equivalent call
	local awaitingQueries3 = isAwaitingQueries({ v8.lifetimeViewsStatus, v8.lifetimeJoinsStatus }) -- inferred equivalent call
	local overviewMetrics = {
		{
			key = "averageWatchTime",
			label = v3.averageWatchTime,
			valueText = v10 == nil and "—" or v13.averageWatchTime,
			isLoading = awaitingQueries
		},
		{
			key = "averageCompletion",
			label = v3.averageCompletion,
			valueText = v11 == nil and "—" or v13.averageCompletion,
			isLoading = awaitingQueries2
		},
		{
			key = "gameJoinConversion",
			label = v3.gameJoinConversion,
			valueText = v12 == nil and "—" or v13.gameJoinConversion,
			isLoading = awaitingQueries3
		}
	}

	local viewsSeries = v8.viewsSeries
	local v16

	if v8.window == nil then
		v16 = false
	else
		v16 = v8.window.granularity == CreatorAnalytics.MetricGranularity.OneHour
	end

	local function formatTime(value: string) -- 1 equivalent call inferred from this helper
		local dateTime2 = DateTime.fromIsoDate(value)

		if dateTime2 == nil then
			return value
		end

		if v16 then
			return (dateTime2:FormatLocalTime("LT", robloxLocaleId))
		end

		return (dateTime2:FormatUniversalTime("MMM D", robloxLocaleId))
	end

	local isViewsChartLoading = v8.viewsStatus == DataStatus.NotReady

	local v17 = not (viewsSeries == nil) and viewsSeries.hasData

	local v18 = v8.lifetimeViewsStatus == DataStatus.NotReady

	if not v17 and lifetimeViews == 0 then
		lifetimeViews = nil
	end

	local v19 = lifetimeViews == nil and "—" or abbreviateCount(lifetimeViews, robloxLocaleId)

	if not (v17 or isViewsChartLoading) then
		table.insert(overviewMetrics, 1, {
			key = "totalViews",
			label = v3.totalViews,
			valueText = v19,
			isLoading = v18
		})
	end

	local viewsChart = {
		plotId = `views:{moment.momentId}`,
		series = viewsSeries ~= nil and {
			{ id = "views", name = v3.totalViews, points = viewsSeries.points }
		} or nil,
		hasData = v17,
		hideHeader = true,
		title = v3.totalViews,
		valueText = v19,
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
	local v20

	if moment.comments == nil then
		v20 = false
	else
		v20 = moment.comments.countIsCapped == true
	end

	local v21 = {
		title = v3.title,
		overviewHeading = v3.overview,
		engagementHeading = v3.engagement,
		totalReactionsLabel = v3.totalReactions,
		onBack = onBack,
		mediaItem = mediaItem,
		caption = 0,
		postedOnText = 0,
		interactionCounts = 0,
		totalViewsLabel = 0,
		totalViewsText = 0,
		isTotalViewsLoading = 0,
		viewsChart = 0,
		isViewsChartLoading = 0,
		isViewsChartVisible = 0,
		overviewMetrics = 0,
		totalReactionsText = 0,
		reactionCounts = 0
	}

	if description == nil or description == "" then
		description = nil
	end

	v21.caption = description
	local postedOnText

	if v14 ~= nil then
		postedOnText = v15.postedOn
	end

	v21.postedOnText = postedOnText
	v21.interactionCounts = {
		{
			key = "likes",
			icon = BuilderIcons.Icon.ThumbUp,
			countText = abbreviateCount(v4 or 0, LocalizationService.RobloxLocaleId)
		},
		{
			key = "comments",
			icon = BuilderIcons.Icon.SpeechBubbleAlignLeft,
			countText = abbreviateCount(v6 or 0, LocalizationService.RobloxLocaleId) .. (v20 and "+" or "")
		},
		{
			key = "shares",
			icon = BuilderIcons.Icon.ArrowThickToRight,
			countText = abbreviateCount(v7 or 0, LocalizationService.RobloxLocaleId)
		}
	}

	v21.totalViewsLabel = v3.totalViews
	v21.totalViewsText = v19
	v21.isTotalViewsLoading = v18
	v21.viewsChart = viewsChart
	v21.isViewsChartLoading = isViewsChartLoading
	v21.isViewsChartVisible = v17
	v21.overviewMetrics = overviewMetrics
	v21.totalReactionsText = abbreviateCount(v4 or 0, LocalizationService.RobloxLocaleId)
	v21.reactionCounts = reactionCounts
	return v21
end

return usePostInsightsPageViewModel
