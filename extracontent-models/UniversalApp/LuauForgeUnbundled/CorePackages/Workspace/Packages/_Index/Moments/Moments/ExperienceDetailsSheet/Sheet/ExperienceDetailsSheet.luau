local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact").useSignalState

local InExperienceDetailsPromptContainer = require("@game/CorePackages/Workspace/Packages/_Index/Moments/InExperienceDetailsPrompt/InExperienceDetailsPromptContainer")

local getExperienceDetailsSheetStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/ExperienceDetailsSheet/Sheet/getExperienceDetailsSheetStore")
local useHideTabBarWhileOpen = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/ExperienceDetailsSheet/Sheet/useHideTabBarWhileOpen")
local useJoinExperience = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/ExperienceDetailsSheet/Join/useJoinExperience")

local FFlagMomentsFixRecommendationImpressionLifecycle = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFixRecommendationImpressionLifecycle")
local FFlagMomentsTabsBehindModalScrim = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsTabsBehindModalScrim")
local FFlagMomentsNavigationEvent = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsNavigationEvent")
local FFlagMomentsPlayEvent = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsPlayEvent")
local NavigationDestinationType = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Enums/NavigationDestinationType")

local analytics = MomentsCommon.Analytics
local eventNames = analytics.EventNames
local fireAnalyticsEvent = analytics.fireAnalyticsEvent

local function ExperienceDetailsSheet()
	local v5 = getExperienceDetailsSheetStore(false)
	local v6 = useSignalState(v5.getIsOpen)

	local v7 = useSignalState(v5.getContext)
	local v8 = useJoinExperience()

	if not FFlagMomentsTabsBehindModalScrim then
		useHideTabBarWhileOpen(v6)
	end

	React.useEffect(function()
		if v6 and v7 then
			if v7.feedItemId == nil or v7.feedItemId == "" then
				local v9 = v7.feedItemId == nil and "nil" or "empty"
				analytics.reportMomentSkip("feed_action", v9, { action = "edp" })
			else
				fireAnalyticsEvent(eventNames.ExperienceDetailsOpened, {
					feedItemId = v7.feedItemId,
					feedSessionId = v7.tracingId or "",
					placeId = tostring(v7.placeId),
					universeId = tostring(v7.universeId)
				})
			end
		end
	end, { v6, v7 })

	local v9 = React.useCallback(function(p2)
		if v7 then
			local v10

			if FFlagMomentsFixRecommendationImpressionLifecycle and v7.onBeforeJoin ~= nil then
				local onBeforeJoin = v7.onBeforeJoin
				local v11 = if FFlagMomentsNavigationEvent then NavigationDestinationType.ExperienceJoin else nil
				v10 = onBeforeJoin(v11)
			end

			if not FFlagMomentsPlayEvent then
				v10 = nil
			end

			v8(v7, p2, v10)
		end

		v5.close()
	end, { v8, v7, v5.close })

	if v6 and v7 ~= nil then
		return React.createElement(InExperienceDetailsPromptContainer, {
			universeId = tostring(v7.universeId),
			onClose = v5.close,
			onJoin = v9
		})
	end

	return nil
end

return React.memo(ExperienceDetailsSheet)
