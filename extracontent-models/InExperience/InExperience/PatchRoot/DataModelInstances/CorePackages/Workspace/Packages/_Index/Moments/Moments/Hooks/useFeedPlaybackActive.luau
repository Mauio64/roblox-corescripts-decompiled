local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local MomentsCommon = require(parent.MomentsCommon)
local Navigation = require(parent.Navigation)
local SignalsReact = require(parent.SignalsReact)
local useNavigationFocus = Navigation.useNavigationFocus
local useSignalState = SignalsReact.useSignalState

local useMomentsTabIsVisible = require(Moments.Hooks.useMomentsTabIsVisible)

local GetMomentsPreferencesStore = require(Moments.Stores.GetMomentsPreferencesStore)

local feedPlaybackSuspension = MomentsCommon.Media.feedPlaybackSuspension

local function useFeedPlaybackActive()
	local v = useNavigationFocus()
	local v2 = useMomentsTabIsVisible()

	local v3 = useSignalState(feedPlaybackSuspension.getSuspended)

	local v4 = useSignalState(GetMomentsPreferencesStore(false).getIsTeleporting)

	return v and v2 and not v3 and not v4
end

return useFeedPlaybackActive
