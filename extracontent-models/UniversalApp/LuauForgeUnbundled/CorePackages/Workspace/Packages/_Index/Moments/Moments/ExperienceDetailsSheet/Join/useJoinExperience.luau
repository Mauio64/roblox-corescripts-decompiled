local HttpService = game:GetService("HttpService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local GameLaunch = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/GameLaunch")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")

local launchGame = GameLaunch.LaunchGame
local useLocalization = Localization.Hooks.useLocalization

local analytics = MomentsCommon.Analytics
local eventNames = analytics.EventNames
local fireAnalyticsEvent = analytics.fireAnalyticsEvent

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Constants")
local module6 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/ExperienceDetailsSheet/Constants")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/ExperienceDetailsSheet/Types")
local emitRecommendationAction = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/emitRecommendationAction")
local useMomentsSession = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/MomentsSessionContext").useMomentsSession
local GetMomentsPreferencesStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsPreferencesStore")
local sessionUtil = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/sessionUtil")
local GetToastStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetToastStore")
local listenForTeleportFailure = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/ExperienceDetailsSheet/Join/listenForTeleportFailure")
local FFlagMomentsPlayEvent = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsPlayEvent")

local v5 = { joining = module6.LocalizationKeys.joining }

local function useJoinExperience()
	local v6 = useLocalization(v5)
	local v7 = useMomentsSession()

	local ref = React.useRef(nil)

	React.useEffect(function()
		return function()
			if ref.current ~= nil then
				ref.current()
				ref.current = nil
			end
		end
	end, {})

	return React.useCallback(function(data, p2, p3)
		local v8 = GetMomentsPreferencesStore(false)

		if ref.current ~= nil then
			ref.current()
			ref.current = nil
		end

		v8.setTeleporting(true)

		local v9 = p2 or data.placeId
		local momentsSessionId = v7.getMomentsSessionId(false)
		local feedItemId = data.feedItemId or ""
		local tracingId = data.tracingId or ""

		if data.feedItemId == nil or data.feedItemId == "" then
			local v10 = data.feedItemId == nil and "nil" or "empty"
			analytics.reportMomentSkip("feed_action", v10, { action = "join" })
		else
			fireAnalyticsEvent(eventNames.FeedExperienceJoinAttempted, {
				feedItemId = data.feedItemId,
				feedSessionId = tracingId,
				placeId = tostring(data.placeId),
				universeId = tostring(data.universeId),
				destinationPlaceId = tostring(v9)
			})
		end

		local v10

		if data.recommendationSource == analytics.RecommendationSource.Following then
			v10 = HttpService:GenerateGUID(false)
		else
			v10 = emitRecommendationAction({
				itemId = feedItemId,
				tracingId = tracingId,
				momentsSessionId = momentsSessionId,
				actionType = Constants.RecommendationActionType.Play,
				destinationPlaceId = v9,
				contentType = data.contentType
			})
		end

		GetToastStore(false).triggerToast({ title = v6.joining, text = "" })

		if v10 then
			sessionUtil.setPlayIntent(v10)
		end

		if FFlagMomentsPlayEvent and v10 ~= nil and data.feedItemId ~= nil and data.feedItemId ~= "" then
			local makeMomentsPlayFields = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/makeMomentsPlayFields")
			fireAnalyticsEvent(
				eventNames.MomentsPlayEvent,
				makeMomentsPlayFields({
					feedItemId = data.feedItemId,
					momentsPlayIntentId = v10,
					viewId = p3,
					clientEventTimestampMs = DateTime.now().UnixTimestampMillis
				})
			)
		end

		ref.current = listenForTeleportFailure(function()
			ref.current = nil
			v8.setTeleporting(false)
		end)

		launchGame(
			tostring(v9),
			module6.JoinReferralPage,
			{ moments_play_intent_id = v10 },
			nil,
			module6.JoinLaunchSource
		)
	end, { v6.joining, v7 })
end

return useJoinExperience
