local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactUtils")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")

local view = Foundation.View

local getMomentsCapabilities = MomentsCommon.Stores.GetMomentsCapabilities
local useSignalBinding = SignalsReact.useSignalBinding
local useSignalState = SignalsReact.useSignalState

local MomentContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentContext")
local RailItem = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/TopContent/ActionRail/RailItem")
local ReactionButton = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/TopContent/ActionRail/ReactionButton")
local ContextualMenu = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/ContextualMenu")
local useMomentsSession = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/MomentsSessionContext").useMomentsSession
local GetMomentsPreferencesStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsPreferencesStore")
local useCommentCapabilities = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/useCommentCapabilities")
local FFlagMomentsActionRailNarrowWidth = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsActionRailNarrowWidth")
local FFlagMomentsActionRailSpacing = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsActionRailSpacing")
local FFlagMomentsCreatorAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCreatorAnalytics")
local FFlagMomentsRecommendationContentType = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsRecommendationContentType")
local fFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local fFlagMomentsComments = SharedFlags.FFlagMomentsComments
local fFlagMomentsCommentsIxpEnabled = SharedFlags.FFlagMomentsCommentsIxpEnabled
local fFlagMomentsReactFeatureGate = SharedFlags.FFlagMomentsReactFeatureGate
local fFlagMomentsServeEDPVideos = SharedFlags.FFlagMomentsServeEDPVideos
local fFlagMomentsEngagementMetricsFeature = MomentsCommon.Flags.FFlagMomentsEngagementMetricsFeature
local useConfiguration = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useConfiguration")
local useShareMoment = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Share/useShareMoment")
local useCommentActionImpression = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/TopContent/ActionRail/useCommentActionImpression")

local arrowThickToRight = BuilderIcons.Icon.ArrowThickToRight
local speechBubbleAlignLeft = BuilderIcons.Icon.SpeechBubbleAlignLeft

local function ActionRail(props)
	local nextOrder = ReactUtils.createNextOrder()

	local v5 = MomentContext.useMoment()
	local store = v5.store
	local data = store.getData(false)
	local v6 = data.kind == "ad"
	local v7

	if fFlagMomentsEngagementMetricsFeature then
		v7 = useSignalState(getMomentsCapabilities(false).getIsEngagementMetricsEnabled)
	end

	local v8 = not fFlagMomentsReactFeatureGate
		or useSignalState(getMomentsCapabilities(false).getCanReactToMoments)

	local v9 = useShareMoment(props.moment)

	local animationRatio = v5.animationRatio
	local v10 = useSignalBinding(store.getShareCount)

	local v11 = if fFlagMomentsComments then useSignalBinding(store.getCommentCount) else nil

	local v12 = useSignalState(store.getIsModerated)
	local v13 = fFlagMomentsOptimisticProfilePending and data.isPending == true
	local v14 = v12 or v13
	local feedItemId

	if props.moment == nil or props.moment.recommendationMetadata == nil then
		feedItemId = nil
	else
		feedItemId = props.moment.recommendationMetadata.feedItemId
	end

	local v15 = v14 or feedItemId == nil or feedItemId == ""

	local v16 = useConfiguration("feed_mute_enabled", false)
	local v17 = useConfiguration("feed_mute_button_analytics_enabled", false)

	local v18 = useMomentsSession()
	local v19 = GetMomentsPreferencesStore(false)

	local v20 = useSignalState(v18.getHideDetails)
	local comments = if props.moment ~= nil then props.moment.comments else nil
	local canRead = useCommentCapabilities().canRead
	local v21 = fFlagMomentsServeEDPVideos

	if v21 then
		v21 = not (props.moment == nil) and props.moment.entityType == "edpVideo"
	end

	local v22 = canRead and not (v20 or v6) and not v21 and (comments == nil or comments.viewerCanRead)

	if fFlagMomentsComments or fFlagMomentsCommentsIxpEnabled then
		useCommentActionImpression(v22 and props.moment ~= nil)
	end

	local v23 = useSignalState(v19.getFeedGlobalMute)
	local v24 = React.useMemo(function()
		return { isMuted = v23, toggle = v19.toggleFeedGlobalMute }
	end, { v23, v19.toggleFeedGlobalMute })

	local children = {}

	if v8 and not (v20 or v6) then
		children.React = React.createElement(ReactionButton, {
			animationRatio = animationRatio,
			isDisabled = v14,
			LayoutOrder = nextOrder()
		})
	end

	if fFlagMomentsComments and v22 then
		local createElement = React.createElement
		local v26 = {
			LayoutOrder = nextOrder(),
			slot = speechBubbleAlignLeft,
			count = 0,
			countIsCapped = 0,
			animationRatio = 0,
			isDisabled = 0,
			onActivated = 0,
			testId = "moments-comment-button"
		}

		if fFlagMomentsEngagementMetricsFeature and not v7 then
			v11 = nil
		end

		v26.count = v11
		v26.countIsCapped = comments ~= nil and comments.countIsCapped == true
		v26.animationRatio = animationRatio
		v26.isDisabled = v14
		function v26.onActivated()
			if not v14 and feedItemId ~= nil and feedItemId ~= "" and props.onOpenComments ~= nil then
				props.onOpenComments()
			end
		end

		children.Comment = createElement(RailItem, v26)
	end

	if not v20 then
		local createElement = React.createElement
		local v26 = {
			LayoutOrder = nextOrder(),
			slot = arrowThickToRight,
			count = 0,
			animationRatio = 0,
			isDisabled = 0,
			onActivated = 0
		}

		if fFlagMomentsEngagementMetricsFeature and not v7 then
			v10 = nil
		end

		v26.count = v10
		v26.animationRatio = animationRatio
		v26.isDisabled = v15
		v26.onActivated = v9.onShareActivated
		children.Share = createElement(RailItem, v26)

		local MusicButton = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/TopContent/ActionRail/MusicButton")
		children.Music = React.createElement(MusicButton, {
			LayoutOrder = nextOrder(),
			moment = props.moment,
			animationRatio = animationRatio,
			isDisabled = v12
		})
	end

	if props.moment ~= nil then
		local createElement = React.createElement
		local v26 = {
			isFeedMuteEnabled = v16,
			isFeedMuteButtonAnalyticsEnabled = v17,
			isDisabled = v12,
			layoutOrder = nextOrder(),
			moment = props.moment,
			contentType = 0,
			momentStore = 0,
			playbackVolume = 0
		}
		local v27 = if FFlagMomentsRecommendationContentType then data.contentType else nil
		v26.contentType = v27

		if not FFlagMomentsCreatorAnalytics then
			store = nil
		end

		v26.momentStore = store
		v26.playbackVolume = v24
		children.ContextualMenu = createElement(ContextualMenu, v26)
	end

	return React.createElement(view, {
		LayoutOrder = props.LayoutOrder,
		tag = FFlagMomentsActionRailNarrowWidth and (FFlagMomentsActionRailSpacing and "col align-x-center gap-large size-1000-0 auto-y" or "col align-x-center size-1000-0 auto-y") or FFlagMomentsActionRailSpacing and "col align-x-center gap-large size-1200-0 auto-y" or "col size-1200-0 auto-y",
		testId = (FFlagMomentsActionRailSpacing or FFlagMomentsActionRailNarrowWidth) and "moments-action-rail" or nil
	}, children)
end

return React.memo(ActionRail)
