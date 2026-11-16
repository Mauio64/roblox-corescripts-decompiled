local HttpService = game:GetService("HttpService")

local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
local GameLaunch = require(parent.GameLaunch)
local Localization = require(parent.Localization)
local MomentsCommon = require(parent.MomentsCommon)

local LaunchGame = GameLaunch.LaunchGame
local useLocalization = Localization.Hooks.useLocalization

local Analytics = MomentsCommon.Analytics
local EventNames = Analytics.EventNames
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent

local Constants = require(Moments.Constants)
local Constants2 = require(Moments.ExperienceDetailsSheet.Constants)
require(Moments.ExperienceDetailsSheet.Types)
local emitRecommendationAction = require(Moments.Analytics.emitRecommendationAction)
local MomentsSessionContext = require(Moments.Stores.GetMomentsStore.MomentsSessionContext)
local useMomentsSession = MomentsSessionContext.useMomentsSession
local GetMomentsPreferencesStore = require(Moments.Stores.GetMomentsPreferencesStore)
local sessionUtil = require(Moments.Analytics.sessionUtil)
local GetToastStore = require(Moments.Stores.GetToastStore)
local listenForTeleportFailure = require(script.Parent.listenForTeleportFailure)
local FFlagMomentsPlayEvent = require(Moments.Flags.FFlagMomentsPlayEvent)

local v = { joining = Constants2.LocalizationKeys.joining }

local function useJoinExperience()
	local v2 = useLocalization(v)
	local v3 = useMomentsSession()

	local ref = React.useRef(nil)

	React.useEffect(function()
		return function()
			if ref.current ~= nil then
				ref.current()
				ref.current = nil
			end
		end
	end, {})

	return React.useCallback(function(data, p: number?, viewId: string?)
		local momentsPreferencesStore = GetMomentsPreferencesStore(false)

		if ref.current ~= nil then
			ref.current()
			ref.current = nil
		end

		momentsPreferencesStore.setTeleporting(true)

		local destinationPlaceId = p or data.placeId
		local momentsSessionId = v3.getMomentsSessionId(false)
		local feedItemId = data.feedItemId or ""
		local tracingId = data.tracingId or ""

		if data.feedItemId == nil or data.feedItemId == "" then
			local v4 = data.feedItemId == nil and "nil" or "empty"
			Analytics.reportMomentSkip("feed_action", v4, { action = "join" })
		else
			fireAnalyticsEvent(EventNames.FeedExperienceJoinAttempted, {
				feedItemId = data.feedItemId,
				feedSessionId = tracingId,
				placeId = tostring(data.placeId),
				universeId = tostring(data.universeId),
				destinationPlaceId = tostring(destinationPlaceId)
			})
		end

		local v4

		if data.recommendationSource == Analytics.RecommendationSource.Following then
			v4 = HttpService:GenerateGUID(false)
		else
			v4 = emitRecommendationAction({
				itemId = feedItemId,
				tracingId = tracingId,
				momentsSessionId = momentsSessionId,
				actionType = Constants.RecommendationActionType.Play,
				destinationPlaceId = destinationPlaceId,
				contentType = data.contentType
			})
		end

		GetToastStore(false).triggerToast({ title = v2.joining, text = "" })

		if v4 then
			sessionUtil.setPlayIntent(v4)
		end

		if FFlagMomentsPlayEvent and v4 ~= nil and data.feedItemId ~= nil and data.feedItemId ~= "" then
			local makeMomentsPlayFields = require(Moments.Analytics.makeMomentsPlayFields)
			fireAnalyticsEvent(
				EventNames.MomentsPlayEvent,
				makeMomentsPlayFields({
					feedItemId = data.feedItemId,
					momentsPlayIntentId = v4,
					viewId = viewId,
					clientEventTimestampMs = DateTime.now().UnixTimestampMillis
				})
			)
		end

		ref.current = listenForTeleportFailure(function()
			ref.current = nil
			momentsPreferencesStore.setTeleporting(false)
		end)

		LaunchGame(
			tostring(destinationPlaceId),
			Constants2.JoinReferralPage,
			{ moments_play_intent_id = v4 },
			nil,
			Constants2.JoinLaunchSource
		)
	end, { v2.joining, v3 })
end

return useJoinExperience
