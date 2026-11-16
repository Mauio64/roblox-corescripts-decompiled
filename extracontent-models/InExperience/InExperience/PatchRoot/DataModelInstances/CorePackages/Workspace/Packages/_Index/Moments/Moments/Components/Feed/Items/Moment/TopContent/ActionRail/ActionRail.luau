local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local SignalsReact = require(parent.SignalsReact)

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
require(parent.MomentsTypes)
local SharedFlags = require(parent.SharedFlags)

local View = Foundation.View

local GetMomentsCapabilities = MomentsCommon.Stores.GetMomentsCapabilities
local useSignalBinding = SignalsReact.useSignalBinding
local useSignalState = SignalsReact.useSignalState

local MomentContext = require(script.Parent.Parent.Parent.MomentContext)
local RailItem = require(script.Parent.RailItem)
local ReactionButton = require(script.Parent.ReactionButton)
local ContextualMenu = require(Moments.Components.Feed.ContextualMenu)
local MomentsSessionContext = require(Moments.Stores.GetMomentsStore.MomentsSessionContext)
local useMomentsSession = MomentsSessionContext.useMomentsSession
local GetMomentsPreferencesStore = require(Moments.Stores.GetMomentsPreferencesStore)
local useCommentCapabilities = require(Moments.Components.Comments.useCommentCapabilities)
local FFlagMomentsActionRailNarrowWidth = require(Moments.Flags.FFlagMomentsActionRailNarrowWidth)
local FFlagMomentsActionRailSpacing = require(Moments.Flags.FFlagMomentsActionRailSpacing)
local FFlagMomentsCreatorAnalytics = require(Moments.Flags.FFlagMomentsCreatorAnalytics)
local FFlagMomentsRecommendationContentType = require(Moments.Flags.FFlagMomentsRecommendationContentType)
local FFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local FFlagMomentsComments = SharedFlags.FFlagMomentsComments
local FFlagMomentsCommentsIxpEnabled = SharedFlags.FFlagMomentsCommentsIxpEnabled
local FFlagMomentsReactFeatureGate = SharedFlags.FFlagMomentsReactFeatureGate
local FFlagMomentsServeEDPVideos = SharedFlags.FFlagMomentsServeEDPVideos
local FFlagMomentsEngagementMetricsFeature = MomentsCommon.Flags.FFlagMomentsEngagementMetricsFeature
local useConfiguration = require(Moments.Hooks.useConfiguration)
local useShareMoment = require(Moments.Share.useShareMoment)
local useCommentActionImpression = require(script.Parent.useCommentActionImpression)

local ArrowThickToRight = BuilderIcons.Icon.ArrowThickToRight
local SpeechBubbleAlignLeft = BuilderIcons.Icon.SpeechBubbleAlignLeft

local function ActionRail(props)
	local nextOrder = ReactUtils.createNextOrder()

	local v = MomentContext.useMoment()
	local store = v.store
	local data = store.getData(false)
	local v2 = data.kind == "ad"
	local v3

	if FFlagMomentsEngagementMetricsFeature then
		v3 = useSignalState(GetMomentsCapabilities(false).getIsEngagementMetricsEnabled)
	end

	local v4 = not FFlagMomentsReactFeatureGate or useSignalState(GetMomentsCapabilities(false).getCanReactToMoments)

	local v5 = useShareMoment(props.moment)

	local animationRatio = v.animationRatio
	local count = useSignalBinding(store.getShareCount)
	local count2

	if FFlagMomentsComments then
		count2 = useSignalBinding(store.getCommentCount)
	end

	local isDisabled = useSignalState(store.getIsModerated)
	local v6 = FFlagMomentsOptimisticProfilePending and data.isPending == true
	local isDisabled2 = isDisabled or v6
	local feedItemId

	if props.moment == nil or props.moment.recommendationMetadata == nil then
		feedItemId = nil
	else
		feedItemId = props.moment.recommendationMetadata.feedItemId
	end

	local isDisabled3 = isDisabled2 or feedItemId == nil or feedItemId == ""

	local isFeedMuteEnabled = useConfiguration("feed_mute_enabled", false)
	local isFeedMuteButtonAnalyticsEnabled = useConfiguration("feed_mute_button_analytics_enabled", false)

	local v7 = useMomentsSession()
	local momentsPreferencesStore = GetMomentsPreferencesStore(false)

	local v8 = useSignalState(v7.getHideDetails)
	local comments

	if props.moment ~= nil then
		comments = props.moment.comments
	end

	local canRead = useCommentCapabilities().canRead
	local v9 = FFlagMomentsServeEDPVideos

	if v9 then
		if props.moment == nil then
			v9 = false
		else
			v9 = props.moment.entityType == "edpVideo"
		end
	end

	local v10 = canRead and not (v8 or v2) and not v9 and (comments == nil or comments.viewerCanRead)

	if FFlagMomentsComments or FFlagMomentsCommentsIxpEnabled then
		useCommentActionImpression(v10 and props.moment ~= nil)
	end

	local isMuted = useSignalState(momentsPreferencesStore.getFeedGlobalMute)
	local playbackVolume = React.useMemo(function()
		return { isMuted = isMuted, toggle = momentsPreferencesStore.toggleFeedGlobalMute }
	end, { isMuted, momentsPreferencesStore.toggleFeedGlobalMute })

	local children = {}

	if v4 and not (v8 or v2) then
		children.React = React.createElement(ReactionButton, {
			animationRatio = animationRatio,
			isDisabled = isDisabled2,
			LayoutOrder = nextOrder()
		})
	end

	if FFlagMomentsComments and v10 then
		local createElement = React.createElement
		local v11 = {
			LayoutOrder = nextOrder(),
			slot = SpeechBubbleAlignLeft,
			count = 0,
			countIsCapped = 0,
			animationRatio = 0,
			isDisabled = 0,
			onActivated = 0,
			testId = "moments-comment-button"
		}

		if FFlagMomentsEngagementMetricsFeature and not v3 then
			count2 = nil
		end

		v11.count = count2
		v11.countIsCapped = comments ~= nil and comments.countIsCapped == true
		v11.animationRatio = animationRatio
		v11.isDisabled = isDisabled2
		function v11.onActivated()
			if not isDisabled2 and feedItemId ~= nil and feedItemId ~= "" and props.onOpenComments ~= nil then
				props.onOpenComments()
			end
		end

		children.Comment = createElement(RailItem, v11)
	end

	if not v8 then
		local createElement = React.createElement
		local v11 = {
			LayoutOrder = nextOrder(),
			slot = ArrowThickToRight,
			count = 0,
			animationRatio = 0,
			isDisabled = 0,
			onActivated = 0
		}

		if FFlagMomentsEngagementMetricsFeature and not v3 then
			count = nil
		end

		v11.count = count
		v11.animationRatio = animationRatio
		v11.isDisabled = isDisabled3
		v11.onActivated = v5.onShareActivated
		children.Share = createElement(RailItem, v11)

		local MusicButton = require(script.Parent.MusicButton)
		children.Music = React.createElement(MusicButton, {
			LayoutOrder = nextOrder(),
			moment = props.moment,
			animationRatio = animationRatio,
			isDisabled = isDisabled
		})
	end

	if props.moment ~= nil then
		local createElement = React.createElement
		local v11 = {
			isFeedMuteEnabled = isFeedMuteEnabled,
			isFeedMuteButtonAnalyticsEnabled = isFeedMuteButtonAnalyticsEnabled,
			isDisabled = isDisabled,
			layoutOrder = nextOrder(),
			moment = props.moment,
			contentType = 0,
			momentStore = 0,
			playbackVolume = 0
		}
		local contentType

		if FFlagMomentsRecommendationContentType then
			contentType = data.contentType
		end

		v11.contentType = contentType

		if not FFlagMomentsCreatorAnalytics then
			store = nil
		end

		v11.momentStore = store
		v11.playbackVolume = playbackVolume
		children.ContextualMenu = createElement(ContextualMenu, v11)
	end

	return React.createElement(View, {
		LayoutOrder = props.LayoutOrder,
		tag = FFlagMomentsActionRailNarrowWidth and (FFlagMomentsActionRailSpacing and "col align-x-center gap-large size-1000-0 auto-y" or "col align-x-center size-1000-0 auto-y") or FFlagMomentsActionRailSpacing and "col align-x-center gap-large size-1200-0 auto-y" or "col size-1200-0 auto-y",
		testId = (FFlagMomentsActionRailSpacing or FFlagMomentsActionRailNarrowWidth) and "moments-action-rail" or nil
	}, children)
end

return React.memo(ActionRail)
