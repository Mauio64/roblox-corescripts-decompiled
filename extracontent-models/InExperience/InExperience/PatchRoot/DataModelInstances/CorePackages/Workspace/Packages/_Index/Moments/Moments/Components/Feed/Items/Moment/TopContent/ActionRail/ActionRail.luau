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
local GetFFlagMomentsMusicButton = require(Moments.Flags.GetFFlagMomentsMusicButton)
local useConfiguration = require(Moments.Hooks.useConfiguration)
local useShareMoment = require(Moments.Share.useShareMoment)
local PaperAirplane = BuilderIcons.Icon.PaperAirplane

local function ActionRail(t1: {[any]: any}) -- line: 51
	-- upvalues: ReactUtils (copy), MomentContext (copy), useShareMoment (copy), useSignalBinding (copy), useSignalState (copy), useConfiguration (copy), useMomentsSession (copy), GetMomentsPreferencesStore (copy), React (copy), ReactionButton (copy), RailItem (copy), PaperAirplane (copy), GetFFlagMomentsMusicButton (copy), ContextualMenu (copy), View (copy)
	local v23 = ReactUtils.createNextOrder()
	local v24 = MomentContext.useMoment()
	local store = v24.store
	local v26 = store.getData(false).kind == "ad"
	local v27 = useShareMoment(t1.moment)
	local animationRatio = v24.animationRatio
	local v29 = useSignalBinding(store.getShareCount)
	local v30 = useSignalState(store.getIsModerated)
	local v31 = useConfiguration("feed_mute_enabled", false)
	local v32 = useConfiguration("feed_mute_button_analytics_enabled", false)
	local v33 = useMomentsSession()
	local v34 = GetMomentsPreferencesStore(false)
	local v35 = useSignalState(v33.getHideDetails)
	local v36 = useSignalState(v34.getFeedGlobalMute)
	local v37 = React.useMemo(function() -- line: 80
		-- upvalues: v36 (copy), v34 (copy)
		return {
			isMuted = v36,
			toggle = v34.toggleFeedGlobalMute
		}
	end, {
		v36,
		v34.toggleFeedGlobalMute
	})
	local t2 = {}

	if not v35 then
		if not v26 then
			t2.React = React.createElement(ReactionButton, {
				animationRatio = animationRatio,
				isDisabled = v30,
				LayoutOrder = v23()
			})
		end

		t2.Share = React.createElement(RailItem, {
			LayoutOrder = v23(),
			slot = PaperAirplane,
			count = v29,
			animationRatio = animationRatio,
			isDisabled = v30,
			onActivated = v27.onShareActivated
		})

		if GetFFlagMomentsMusicButton() then
			local MusicButton = require(script.Parent.MusicButton)

			t2.Music = React.createElement(MusicButton, {
				LayoutOrder = v23(),
				moment = t1.moment,
				animationRatio = animationRatio,
				isDisabled = v30
			})
		end
	end

	if t1.moment ~= nil then
		t2.ContextualMenu = React.createElement(ContextualMenu, {
			isFeedMuteEnabled = v31,
			isFeedMuteButtonAnalyticsEnabled = v32,
			isDisabled = v30,
			layoutOrder = v23(),
			moment = t1.moment,
			playbackVolume = v37
		})
	end

	return React.createElement(View, {
		tag = "col size-1200-0 auto-y",
		LayoutOrder = t1.LayoutOrder
	}, t2)
end

return React.memo(ActionRail)
