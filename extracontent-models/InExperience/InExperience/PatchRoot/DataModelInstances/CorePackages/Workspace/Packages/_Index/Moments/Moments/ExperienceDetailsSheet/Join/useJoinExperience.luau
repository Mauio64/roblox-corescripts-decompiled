local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local React = require(MomentsParent.React)
local GameLaunch = require(MomentsParent.GameLaunch)
local Localization = require(MomentsParent.Localization)
local MomentsCommon = require(MomentsParent.MomentsCommon)
local LaunchGame = GameLaunch.LaunchGame
local useLocalization = Localization.Hooks.useLocalization
local Analytics = MomentsCommon.Analytics
local EventNames = Analytics.EventNames
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent
local Constants = require(Moments.Constants)
local Constants2 = require(Moments.ExperienceDetailsSheet.Constants)

require(Moments.ExperienceDetailsSheet.Types)

local emitRecommendationAction = require(Moments.Analytics.emitRecommendationAction)
local useMomentsSession = require(Moments.Stores.GetMomentsStore.MomentsSessionContext).useMomentsSession
local GetMomentsPreferencesStore = require(Moments.Stores.GetMomentsPreferencesStore)
local sessionUtil = require(Moments.Analytics.sessionUtil)
local GetToastStore = require(Moments.Stores.GetToastStore)
local listenForTeleportFailure = require(script.Parent.listenForTeleportFailure)
local GetFFlagMomentsPauseAudioThroughTeleport = require(Moments.Flags.GetFFlagMomentsPauseAudioThroughTeleport)
local t1 = {
	joining = Constants2.LocalizationKeys.joining
}

local function useJoinExperience() -- line: 58
	-- upvalues: useLocalization (copy), t1 (copy), useMomentsSession (copy), React (copy), GetMomentsPreferencesStore (copy), GetFFlagMomentsPauseAudioThroughTeleport (copy), fireAnalyticsEvent (copy), EventNames (copy), emitRecommendationAction (copy), Constants (copy), GetToastStore (copy), sessionUtil (copy), listenForTeleportFailure (copy), LaunchGame (copy), Constants2 (copy)
	local v23 = useLocalization(t1)
	local v24 = useMomentsSession()
	local v25 = React.useRef(nil)

	React.useEffect(function() -- line: 66
		-- upvalues: v25 (copy)
		return function() -- line: 67
			-- upvalues: v25 (copy)
			if v25.current ~= nil then
				v25.current()
				v25.current = nil
			end
		end
	end, {})

	return React.useCallback(function(p1, n1: number?) -- line: 75
		-- upvalues: GetMomentsPreferencesStore (copy), GetFFlagMomentsPauseAudioThroughTeleport (copy), v25 (copy), v24 (copy), fireAnalyticsEvent (copy), EventNames (copy), emitRecommendationAction (copy), Constants (copy), GetToastStore (copy), v23 (copy), sessionUtil (copy), listenForTeleportFailure (copy), LaunchGame (copy), Constants2 (copy)
		local v28 = GetMomentsPreferencesStore(false)
		local v29 = GetFFlagMomentsPauseAudioThroughTeleport()

		if v25.current ~= nil then
			v25.current()
			v25.current = nil
		end

		v28.setTeleporting(true)

		local v30 = n1 or p1.placeId
		local v31 = v24.getMomentsSessionId(false)
		local v32 = p1.itemId or ""
		local v33 = p1.tracingId or ""

		fireAnalyticsEvent(EventNames.FeedExperienceJoinAttempted, {
			moments_session_id = v31,
			item_id = v32,
			tracing_id = v33,
			destination_placeid = tostring(v30)
		})

		local v34 = emitRecommendationAction({
			itemId = v32,
			tracingId = v33,
			momentsSessionId = v31,
			actionType = Constants.RecommendationActionType.Play,
			destinationPlaceId = v30
		})

		GetToastStore(false).triggerToast({
			text = "",
			title = v23.joining
		})

		if v34 then
			sessionUtil.setPlayIntent(v34)
		end

		if v29 then
			v25.current = listenForTeleportFailure(function() -- line: 127
				-- upvalues: v25 (copy), v28 (copy)
				v25.current = nil
				v28.setTeleporting(false)
			end)
		end

		LaunchGame(tostring(v30), Constants2.JoinReferralPage, {
			moments_play_intent_id = v34
		}, nil, Constants2.JoinLaunchSource)

		if not v29 then
			task.delay(6, function() -- line: 144
				-- upvalues: v28 (copy)
				v28.setTeleporting(false)
			end)
		end
	end, {
		v23.joining,
		v24
	})
end

return useJoinExperience
