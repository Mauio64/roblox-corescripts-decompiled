local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local React = require(MomentsParent.React)
local ReactUtils = require(MomentsParent.ReactUtils)
local SignalsReact = require(MomentsParent.SignalsReact)
local BuilderIcons = require(MomentsParent.BuilderIcons)
local Foundation = require(MomentsParent.Foundation)

require(MomentsParent.MomentsTypes)

local SharedFlags = require(MomentsParent.SharedFlags)
local View = Foundation.View
local useSignalBinding = SignalsReact.useSignalBinding
local useSignalState = SignalsReact.useSignalState
local MomentContext = require(script.Parent.Parent.Parent.MomentContext)
local RailItem = require(script.Parent.RailItem)
local ReactionButton = require(script.Parent.ReactionButton)
local ContextualMenu = require(Moments.Components.Feed.ContextualMenu)
local useMomentsSession = require(Moments.Stores.GetMomentsStore.MomentsSessionContext).useMomentsSession
local GetMomentsPreferencesStore = require(Moments.Stores.GetMomentsPreferencesStore)
local FFlagMomentsFixFeedShareArrowIcon = require(Moments.Flags.FFlagMomentsFixFeedShareArrowIcon)
local FFlagMomentsPassFeedItemIdToBackendApis = SharedFlags.FFlagMomentsPassFeedItemIdToBackendApis
local GetFFlagMomentsMusicButton = require(Moments.Flags.GetFFlagMomentsMusicButton)
local useConfiguration = require(Moments.Hooks.useConfiguration)
local useShareMoment = require(Moments.Share.useShareMoment)
local PaperAirplane = BuilderIcons.Icon.PaperAirplane
local ArrowThickToRight = BuilderIcons.Icon.ArrowThickToRight

local function ActionRail(t1: {[any]: any}) -- line: 55
	-- upvalues: ReactUtils (copy), MomentContext (copy), useShareMoment (copy), useSignalBinding (copy), useSignalState (copy), FFlagMomentsPassFeedItemIdToBackendApis (copy), useConfiguration (copy), useMomentsSession (copy), GetMomentsPreferencesStore (copy), React (copy), ReactionButton (copy), RailItem (copy), FFlagMomentsFixFeedShareArrowIcon (copy), ArrowThickToRight (copy), PaperAirplane (copy), GetFFlagMomentsMusicButton (copy), ContextualMenu (copy), View (copy)
	local v27 = ReactUtils.createNextOrder()
	local v28 = MomentContext.useMoment()
	local store = v28.store
	local v30 = store.getData(false).kind == "ad"
	local v31 = useShareMoment(t1.moment)
	local animationRatio = v28.animationRatio
	local v33 = useSignalBinding(store.getShareCount)
	local v34 = useSignalState(store.getIsModerated)
	local v35 = if t1.moment == nil or t1.moment.recommendationMetadata == nil then nil else t1.moment.recommendationMetadata.feedItemId
	local v36 = v34 or FFlagMomentsPassFeedItemIdToBackendApis and (v35 == nil or v35 == "")
	local v37 = useConfiguration("feed_mute_enabled", false)
	local v38 = useConfiguration("feed_mute_button_analytics_enabled", false)
	local v39 = useMomentsSession()
	local v40 = GetMomentsPreferencesStore(false)
	local v41 = useSignalState(v39.getHideDetails)
	local v42 = useSignalState(v40.getFeedGlobalMute)
	local v43 = React.useMemo(function() -- line: 91
		-- upvalues: v42 (copy), v40 (copy)
		return {
			isMuted = v42,
			toggle = v40.toggleFeedGlobalMute
		}
	end, {
		v42,
		v40.toggleFeedGlobalMute
	})
	local t2 = {}

	if not v41 then
		if not v30 then
			t2.React = React.createElement(ReactionButton, {
				animationRatio = animationRatio,
				isDisabled = v34,
				LayoutOrder = v27()
			})
		end

		t2.Share = React.createElement(RailItem, {
			LayoutOrder = v27(),
			slot = if not FFlagMomentsFixFeedShareArrowIcon then PaperAirplane else ArrowThickToRight,
			count = v33,
			animationRatio = animationRatio,
			isDisabled = v36,
			onActivated = v31.onShareActivated
		})

		if GetFFlagMomentsMusicButton() then
			local MusicButton = require(script.Parent.MusicButton)

			t2.Music = React.createElement(MusicButton, {
				LayoutOrder = v27(),
				moment = t1.moment,
				animationRatio = animationRatio,
				isDisabled = v34
			})
		end
	end

	if t1.moment ~= nil then
		t2.ContextualMenu = React.createElement(ContextualMenu, {
			isFeedMuteEnabled = v37,
			isFeedMuteButtonAnalyticsEnabled = v38,
			isDisabled = v34,
			layoutOrder = v27(),
			moment = t1.moment,
			playbackVolume = v43
		})
	end

	return React.createElement(View, {
		tag = "col size-1200-0 auto-y",
		LayoutOrder = t1.LayoutOrder
	}, t2)
end

return React.memo(ActionRail)
