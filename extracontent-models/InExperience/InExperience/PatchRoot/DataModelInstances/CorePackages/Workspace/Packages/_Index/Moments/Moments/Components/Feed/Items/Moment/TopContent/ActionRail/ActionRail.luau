local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local React = require(MomentsParent.React)
local ReactUtils = require(MomentsParent.ReactUtils)
local SignalsReact = require(MomentsParent.SignalsReact)
local BuilderIcons = require(MomentsParent.BuilderIcons)
local Foundation = require(MomentsParent.Foundation)

require(MomentsParent.MomentsTypes)

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
local GetFFlagMomentsMusicButton = require(Moments.Flags.GetFFlagMomentsMusicButton)
local useConfiguration = require(Moments.Hooks.useConfiguration)
local useShareMoment = require(Moments.Share.useShareMoment)
local PaperAirplane = BuilderIcons.Icon.PaperAirplane
local ArrowThickToRight = BuilderIcons.Icon.ArrowThickToRight

local function ActionRail(t1: {[any]: any}) -- line: 53
	-- upvalues: ReactUtils (copy), MomentContext (copy), useShareMoment (copy), useSignalBinding (copy), useSignalState (copy), useConfiguration (copy), useMomentsSession (copy), GetMomentsPreferencesStore (copy), React (copy), ReactionButton (copy), RailItem (copy), FFlagMomentsFixFeedShareArrowIcon (copy), ArrowThickToRight (copy), PaperAirplane (copy), GetFFlagMomentsMusicButton (copy), ContextualMenu (copy), View (copy)
	local v25 = ReactUtils.createNextOrder()
	local v26 = MomentContext.useMoment()
	local store = v26.store
	local v28 = store.getData(false).kind == "ad"
	local v29 = useShareMoment(t1.moment)
	local animationRatio = v26.animationRatio
	local v31 = useSignalBinding(store.getShareCount)
	local v32 = useSignalState(store.getIsModerated)
	local v33 = useConfiguration("feed_mute_enabled", false)
	local v34 = useConfiguration("feed_mute_button_analytics_enabled", false)
	local v35 = useMomentsSession()
	local v36 = GetMomentsPreferencesStore(false)
	local v37 = useSignalState(v35.getHideDetails)
	local v38 = useSignalState(v36.getFeedGlobalMute)
	local v39 = React.useMemo(function() -- line: 82
		-- upvalues: v38 (copy), v36 (copy)
		return {
			isMuted = v38,
			toggle = v36.toggleFeedGlobalMute
		}
	end, {
		v38,
		v36.toggleFeedGlobalMute
	})
	local t2 = {}

	if not v37 then
		if not v28 then
			t2.React = React.createElement(ReactionButton, {
				animationRatio = animationRatio,
				isDisabled = v32,
				LayoutOrder = v25()
			})
		end

		t2.Share = React.createElement(RailItem, {
			LayoutOrder = v25(),
			slot = if not FFlagMomentsFixFeedShareArrowIcon then PaperAirplane else ArrowThickToRight,
			count = v31,
			animationRatio = animationRatio,
			isDisabled = v32,
			onActivated = v29.onShareActivated
		})

		if GetFFlagMomentsMusicButton() then
			local MusicButton = require(script.Parent.MusicButton)

			t2.Music = React.createElement(MusicButton, {
				LayoutOrder = v25(),
				moment = t1.moment,
				animationRatio = animationRatio,
				isDisabled = v32
			})
		end
	end

	if t1.moment ~= nil then
		t2.ContextualMenu = React.createElement(ContextualMenu, {
			isFeedMuteEnabled = v33,
			isFeedMuteButtonAnalyticsEnabled = v34,
			isDisabled = v32,
			layoutOrder = v25(),
			moment = t1.moment,
			playbackVolume = v39
		})
	end

	return React.createElement(View, {
		tag = "col size-1200-0 auto-y",
		LayoutOrder = t1.LayoutOrder
	}, t2)
end

return React.memo(ActionRail)
