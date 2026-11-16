local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local useSignalState = SignalsReact.useSignalState

local InExperienceDetailsPromptContainer = require(parent.InExperienceDetailsPrompt.InExperienceDetailsPromptContainer)

local getExperienceDetailsSheetStore = require(script.Parent.getExperienceDetailsSheetStore)
local useHideTabBarWhileOpen = require(script.Parent.useHideTabBarWhileOpen)
local useJoinExperience = require(Moments.ExperienceDetailsSheet.Join.useJoinExperience)

local FFlagMomentsFixRecommendationImpressionLifecycle = require(Moments.Flags.FFlagMomentsFixRecommendationImpressionLifecycle)
local FFlagMomentsTabsBehindModalScrim = require(Moments.Flags.FFlagMomentsTabsBehindModalScrim)
local FFlagMomentsNavigationEvent = require(Moments.Flags.FFlagMomentsNavigationEvent)
local FFlagMomentsPlayEvent = require(Moments.Flags.FFlagMomentsPlayEvent)
local NavigationDestinationType = require(Moments.Enums.NavigationDestinationType)

local Analytics = MomentsCommon.Analytics
local EventNames = Analytics.EventNames
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent

local function ExperienceDetailsSheet()
	local experienceDetailsSheetStore = getExperienceDetailsSheetStore(false)
	local v = useSignalState(experienceDetailsSheetStore.getIsOpen)

	local v2 = useSignalState(experienceDetailsSheetStore.getContext)
	local v3 = useJoinExperience()

	if not FFlagMomentsTabsBehindModalScrim then
		useHideTabBarWhileOpen(v)
	end

	React.useEffect(function()
		if v and v2 then
			if v2.feedItemId == nil or v2.feedItemId == "" then
				local v4 = v2.feedItemId == nil and "nil" or "empty"
				Analytics.reportMomentSkip("feed_action", v4, { action = "edp" })
			else
				fireAnalyticsEvent(EventNames.ExperienceDetailsOpened, {
					feedItemId = v2.feedItemId,
					feedSessionId = v2.tracingId or "",
					placeId = tostring(v2.placeId),
					universeId = tostring(v2.universeId)
				})
			end
		end
	end, { v, v2 })

	local onJoin = React.useCallback(function(p: number?)
		if v2 then
			local v4

			if FFlagMomentsFixRecommendationImpressionLifecycle and v2.onBeforeJoin ~= nil then
				local onBeforeJoin = v2.onBeforeJoin
				local v5

				if FFlagMomentsNavigationEvent then
					v5 = NavigationDestinationType.ExperienceJoin
				end

				v4 = onBeforeJoin(v5)
			end

			if not FFlagMomentsPlayEvent then
				v4 = nil
			end

			v3(v2, p, v4)
		end

		experienceDetailsSheetStore.close()
	end, { v3, v2, experienceDetailsSheetStore.close })

	if v and v2 ~= nil then
		return React.createElement(InExperienceDetailsPromptContainer, {
			universeId = tostring(v2.universeId),
			onClose = experienceDetailsSheetStore.close,
			onJoin = onJoin
		})
	end

	return nil
end

return React.memo(ExperienceDetailsSheet)
