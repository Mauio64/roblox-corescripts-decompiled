local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local MomentsCommon = require(MomentsParent.MomentsCommon)
local Navigation = require(MomentsParent.Navigation)
local SignalsReact = require(MomentsParent.SignalsReact)
local useNavigationFocus = Navigation.useNavigationFocus
local useSignalState = SignalsReact.useSignalState
local useMomentsTabIsVisible = require(Moments.Hooks.useMomentsTabIsVisible)
local GetMomentsPreferencesStore = require(Moments.Stores.GetMomentsPreferencesStore)
local feedPlaybackSuspension = MomentsCommon.Media.feedPlaybackSuspension

local function useFeedPlaybackActive() -- line: 45
	-- upvalues: useNavigationFocus (copy), useMomentsTabIsVisible (copy), useSignalState (copy), feedPlaybackSuspension (copy), GetMomentsPreferencesStore (copy)
	local v12 = useNavigationFocus()
	local v13 = useMomentsTabIsVisible()
	local v14 = useSignalState(feedPlaybackSuspension.getSuspended)
	local v15 = useSignalState(GetMomentsPreferencesStore(false).getIsTeleporting)

	return v12 and (v13 and (not v14 and not v15))
end

return useFeedPlaybackActive
