local LocalizationService = game:GetService("LocalizationService")

require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/AnalyticsMetricChart")
local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
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
local makeFeedActionFields = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/makeFeedActionFields")
local postInsightsStrings = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/postInsightsStrings")
local usePostInsightsAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/usePostInsightsAnalytics")
local toMediaItem = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Media/toMediaItem")

local dataStatus = CreatorAnalytics.DataStatus
local eventNames = MomentsCommon.Analytics.EventNames

local function isAwaitingQueries(items)
	local v5 = false

	for k, item in items do
		if item == dataStatus.Failed then
			return false
		end

		if item == dataStatus.NotReady then
			v5 = true
		end
	end

	return v5
end

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

local function usePostInsightsPageViewModel(p2, callback)
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

	local function logPageEvent(p3, p4, p5)
		local recommendationMetadata = moment.recommendationMetadata

		local momentId = moment.momentId
		local feedItemId = if recommendationMetadata ~= nil then recommendationMetadata.feedItemId else nil
		local v16 = if recommendationMetadata ~= nil then recommendationMetadata.tracingId else nil
		local v17 = makeFeedActionFields(momentId, feedItemId, v16, p4)

		if v17 ~= nil then
			if p5 ~= nil then
				v17.durationMs = tostring(p5)
			end

			MomentsCommon.Analytics.fireAnalyticsEvent(p3, v17)
		end
	end

	local v15 = not (v14.viewsStatus == dataStatus.NotReady) and v14.lifetimeStatus ~= dataStatus.NotReady
	local ref = React.useRef(false)
	React.useEffect(function()
		if not v15 or ref.current then
			return
		end

		ref.current = true
		local postInsightsPageImpression = eventNames.PostInsightsPageImpression
		local recommendationMetadata = moment.recommendationMetadata

		local momentId = moment.momentId
		local feedItemId = if recommendationMetadata ~= nil then recommendationMetadata.feedItemId else nil
		local v17 = if recommendationMetadata ~= nil then recommendationMetadata.tracingId else nil
		local v18 = makeFeedActionFields(momentId, feedItemId, v17, "post_insights_impression")

		if v18 ~= nil then
			MomentsCommon.Analytics.fireAnalyticsEvent(postInsightsPageImpression, v18)
		end
	end, { v15 })

	local ref2 = React.useRef(os.clock())

	local v16 = React.useCallback(function()
		local v17 = math.round((os.clock() - ref2.current) * 1000)
		local postInsightsBackButtonPressed = eventNames.PostInsightsBackButtonPressed
		local recommendationMetadata = moment.recommendationMetadata

		local momentId = moment.momentId
		local feedItemId = if recommendationMetadata ~= nil then recommendationMetadata.feedItemId else nil
		local v19 = if recommendationMetadata ~= nil then recommendationMetadata.tracingId else nil
		local v20 = makeFeedActionFields(momentId, feedItemId, v19, "post_insights_back")

		if v20 ~= nil then
			if v17 ~= nil then
				v20.durationMs = tostring(v17)
			end

			MomentsCommon.Analytics.fireAnalyticsEvent(postInsightsBackButtonPressed, v20)
		end

		callback()
	end, { callback, moment })

	local lifetimeViews = v14.lifetimeViews
	local v17 = nil
	local v18 = nil
	local v19 = nil

	if lifetimeViews ~= nil and lifetimeViews > 0 then
		if v14.lifetimeWatchTimeSeconds ~= nil then
			v17 = math.round(v14.lifetimeWatchTimeSeconds / lifetimeViews)
		end

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

		if v14.lifetimeWatchTimeNoReplaySeconds ~= nil and v20 ~= nil then
			v18 = math.min(v14.lifetimeWatchTimeNoReplaySeconds / lifetimeViews / v20, 1)
		end

		if v14.lifetimeJoins ~= nil then
			v19 = v14.lifetimeJoins / lifetimeViews
		end
	end

	local v21 = useLocalization((React.useMemo(function()
		return {
			averageWatchTime = {
				postInsightsStrings.DURATION_SECONDS_KEY,
				seconds = v17 or 0
			},
			averageCompletion = {
				postInsightsStrings.PERCENT_KEY,
				number = numberLocalization.localize((math.round)((v18 or 0) * 1000) / 10, robloxLocaleId)
			},
			gameJoinConversion = {
				postInsightsStrings.PERCENT_KEY,
				number = numberLocalization.localize((math.round)((v19 or 0) * 1000) / 10, robloxLocaleId)
			}
		}
	end, {
		v17 or false,
		v18 or false,
		v19 or false,
		robloxLocaleId
	})))

	local dateTime = if moment.createdAt ~= nil then DateTime.fromIsoDate(moment.createdAt) else nil

	local v22 = if dateTime ~= nil then dateTime:FormatLocalTime("L", robloxLocaleId) else nil
	local v24 = useLocalization((React.useMemo(function()
		return {
			postedOn = {
				postInsightsStrings.POSTED_ON_DATE_KEY,
				date = v22 or ""
			}
		}
	end, { v22 or false })))
	local v25 = false

	for k, v27 in { v14.lifetimeViewsStatus, v14.lifetimeWatchTimeStatus } do
		if v27 == dataStatus.Failed then
			v25 = false
			break
		elseif v27 == dataStatus.NotReady then
			v25 = true
		end
	end

	local v27 = false

	for k, v29 in { v14.lifetimeViewsStatus, v14.lifetimeWatchTimeNoReplayStatus } do
		if v29 == dataStatus.Failed then
			v27 = false
			break
		elseif v29 == dataStatus.NotReady then
			v27 = true
		end
	end

	local v29 = false

	for k, v31 in { v14.lifetimeViewsStatus, v14.lifetimeJoinsStatus } do
		if v31 == dataStatus.Failed then
			v29 = false
			break
		elseif v31 == dataStatus.NotReady then
			v29 = true
		end
	end

	local v31 = {
		{
			key = "averageWatchTime",
			label = v7.averageWatchTime,
			valueText = v17 == nil and "—" or v21.averageWatchTime,
			isLoading = v25
		},
		{
			key = "averageCompletion",
			label = v7.averageCompletion,
			valueText = v18 == nil and "—" or v21.averageCompletion,
			isLoading = v27
		},
		{
			key = "gameJoinConversion",
			label = v7.gameJoinConversion,
			valueText = v19 == nil and "—" or v21.gameJoinConversion,
			isLoading = v29
		}
	}

	local viewsSeries = v14.viewsSeries

	local v32 = not (v14.window == nil) and v14.window.granularity == CreatorAnalytics.MetricGranularity.OneHour
	local function formatTime(p3)
		local dateTime2 = DateTime.fromIsoDate(p3)

		if dateTime2 == nil then
			return p3
		end

		if v32 then
			return (dateTime2:FormatLocalTime("LT", robloxLocaleId))
		end

		return (dateTime2:FormatUniversalTime("MMM D", robloxLocaleId))
	end

	local v33 = v14.viewsStatus == dataStatus.NotReady

	local v34 = not (viewsSeries == nil) and viewsSeries.hasData

	local v35 = v14.lifetimeViewsStatus == dataStatus.NotReady

	if not v34 and lifetimeViews == 0 then
		lifetimeViews = nil
	end

	local v36 = lifetimeViews == nil and "—" or abbreviateCount(lifetimeViews, robloxLocaleId)

	if not (v34 or v33) then
		table.insert(v31, 1, {
			key = "totalViews",
			label = v7.totalViews,
			valueText = v36,
			isLoading = v35
		})
	end

	local v37 = {
		plotId = `views:{moment.momentId}`,
		series = viewsSeries ~= nil and {
			{ id = "views", name = v7.totalViews, points = viewsSeries.points }
		} or nil,
		hasData = v34,
		hideHeader = true,
		title = v7.totalViews,
		valueText = v36,
		isDeltaPositive = false,
		yAxisFormatter = function(p3)
			return abbreviateCount(p3.value, robloxLocaleId)
		end,
		xAxisFormatter = function(p3)
			local value = p3.value
			local dateTime2 = DateTime.fromIsoDate(value)

			if dateTime2 == nil then
				return value
			end

			if v32 then
				return (dateTime2:FormatLocalTime("LT", robloxLocaleId))
			end

			return (dateTime2:FormatUniversalTime("MMM D", robloxLocaleId))
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
	local v38 = not (moment.comments == nil) and moment.comments.countIsCapped == true
	local v39 = {
		title = v7.title,
		overviewHeading = v7.overview,
		engagementHeading = v7.engagement,
		totalReactionsLabel = v7.totalReactions,
		onBack = v16,
		mediaItem = v12,
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

	v39.caption = description
	local v40 = if v22 ~= nil then v24.postedOn else nil
	v39.postedOnText = v40
	v39.interactionCounts = {
		{
			key = "likes",
			icon = BuilderIcons.Icon.ThumbUp,
			countText = abbreviateCount(v8 or 0, LocalizationService.RobloxLocaleId)
		},
		{
			key = "comments",
			icon = BuilderIcons.Icon.SpeechBubbleAlignLeft,
			countText = abbreviateCount(v10 or 0, LocalizationService.RobloxLocaleId) .. (v38 and "+" or "")
		},
		{
			key = "shares",
			icon = BuilderIcons.Icon.ArrowThickToRight,
			countText = abbreviateCount(v11 or 0, LocalizationService.RobloxLocaleId)
		}
	}

	v39.totalViewsLabel = v7.totalViews
	v39.totalViewsText = v36
	v39.isTotalViewsLoading = v35
	v39.viewsChart = v37
	v39.isViewsChartLoading = v33
	v39.isViewsChartVisible = v34
	v39.overviewMetrics = v31
	v39.totalReactionsText = abbreviateCount(v8 or 0, LocalizationService.RobloxLocaleId)
	v39.reactionCounts = v13
	return v39
end

return usePostInsightsPageViewModel
