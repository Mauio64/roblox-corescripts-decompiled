local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Navigation")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")
local useNavigationFocus = Navigation.useNavigationFocus
local useSignalState = SignalsReact.useSignalState

local useMomentsTabIsVisible = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useMomentsTabIsVisible")

local GetMomentsPreferencesStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsPreferencesStore")

local feedPlaybackSuspension = MomentsCommon.Media.feedPlaybackSuspension

local function useFeedPlaybackActive()
	local v5 = useNavigationFocus()
	local v6 = useMomentsTabIsVisible()

	local v7 = useSignalState(feedPlaybackSuspension.getSuspended)

	local v8 = useSignalState(GetMomentsPreferencesStore(false).getIsTeleporting)

	return v5 and v6 and not v7 and not v8
end

return useFeedPlaybackActive
