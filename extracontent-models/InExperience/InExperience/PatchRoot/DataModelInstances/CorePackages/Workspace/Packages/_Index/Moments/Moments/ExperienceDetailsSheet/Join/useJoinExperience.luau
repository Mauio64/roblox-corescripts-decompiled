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
local GetFFlagMomentsAnalyticsSchemaIdentity = MomentsCommon.Flags.GetFFlagMomentsAnalyticsSchemaIdentity
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

local function useJoinExperience() -- line: 59
	-- upvalues: useLocalization (copy), t1 (copy), useMomentsSession (copy), React (copy), GetMomentsPreferencesStore (copy), GetFFlagMomentsPauseAudioThroughTeleport (copy), GetFFlagMomentsAnalyticsSchemaIdentity (copy), fireAnalyticsEvent (copy), EventNames (copy), Analytics (copy), emitRecommendationAction (copy), Constants (copy), GetToastStore (copy), sessionUtil (copy), listenForTeleportFailure (copy), LaunchGame (copy), Constants2 (copy)
	local v24 = useLocalization(t1)
	local v25 = useMomentsSession()
	local v26 = React.useRef(nil)

	React.useEffect(function() -- line: 67
		-- upvalues: v26 (copy)
		return function() -- line: 68
			-- upvalues: v26 (copy)
			if v26.current ~= nil then
				v26.current()
				v26.current = nil
			end
		end
	end, {})

	return React.useCallback(function(p1, n1: number?) -- line: 76
		-- upvalues: GetMomentsPreferencesStore (copy), GetFFlagMomentsPauseAudioThroughTeleport (copy), v26 (copy), v25 (copy), GetFFlagMomentsAnalyticsSchemaIdentity (copy), fireAnalyticsEvent (copy), EventNames (copy), Analytics (copy), emitRecommendationAction (copy), Constants (copy), GetToastStore (copy), v24 (copy), sessionUtil (copy), listenForTeleportFailure (copy), LaunchGame (copy), Constants2 (copy)
		local v29 = GetMomentsPreferencesStore(false)
		local v30 = GetFFlagMomentsPauseAudioThroughTeleport()

		if v26.current ~= nil then
			v26.current()
			v26.current = nil
		end

		v29.setTeleporting(true)

		local v31 = n1 or p1.placeId
		local v32 = v25.getMomentsSessionId(false)
		local v33 = p1.itemId or ""
		local v34 = p1.feedItemId or ""
		local v35 = p1.tracingId or ""

		if GetFFlagMomentsAnalyticsSchemaIdentity() then
			if p1.feedItemId ~= nil and p1.feedItemId ~= "" then
				fireAnalyticsEvent(EventNames.FeedExperienceJoinAttempted, {
					feedItemId = p1.feedItemId,
					feedSessionId = v35,
					placeId = tostring(p1.placeId),
					universeId = tostring(p1.universeId),
					destinationPlaceId = tostring(v31)
				})
			else
				local v36 = p1.feedItemId ~= nil and "empty" or "nil"

				Analytics.reportMomentSkip("feed_action", v36, {
					action = "join"
				})
			end
		else
			fireAnalyticsEvent(EventNames.FeedExperienceJoinAttempted, {
				moments_session_id = v32,
				item_id = v33,
				tracing_id = v35,
				destination_placeid = tostring(v31)
			})
		end

		local v37 = emitRecommendationAction({
			itemId = v34,
			tracingId = v35,
			momentsSessionId = v32,
			actionType = Constants.RecommendationActionType.Play,
			destinationPlaceId = v31
		})

		GetToastStore(false).triggerToast({
			text = "",
			title = v24.joining
		})

		if v37 then
			sessionUtil.setPlayIntent(v37)
		end

		if v30 then
			v26.current = listenForTeleportFailure(function() -- line: 155
				-- upvalues: v26 (copy), v29 (copy)
				v26.current = nil
				v29.setTeleporting(false)
			end)
		end

		LaunchGame(tostring(v31), Constants2.JoinReferralPage, {
			moments_play_intent_id = v37
		}, nil, Constants2.JoinLaunchSource)

		if not v30 then
			task.delay(6, function() -- line: 172
				-- upvalues: v29 (copy)
				v29.setTeleporting(false)
			end)
		end
	end, {
		v24.joining,
		v25
	})
end

return useJoinExperience
