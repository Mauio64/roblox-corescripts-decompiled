local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks").useRoactService
local roactAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactServiceTags").RoactAnalytics

local appEventIngestService = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactServiceTags").AppEventIngestService

local sendItemImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UnifiedLogging").SendItemImpressions

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppEnums").AppPage

local useProfileAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileAnalyticsContext")

local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")

return function(p2, p3, p4, p5, p6)
	local v5 = useRoactService(appEventIngestService)
	local v6 = useRoactService(roactAnalytics)
	local profilePlatform = appPage.ProfilePlatform
	local v7 = useProfileAnalyticsContext()

	return React.useCallback(function(p7)
		v7.fireAnalyticsEvent(EventNames.ProfileImpressionsSent, { component = p6 })

		if sendItemImpressions and sendItemImpressions.sendFromProfile then
			sendItemImpressions.sendFromProfile(v5, v6, p7, p2, p3, profilePlatform, p4, p5, p6)
		end
	end, {
		v6,
		p5,
		p6,
		p4,
		v5,
		profilePlatform,
		p2,
		p3,
		sendItemImpressions
	})
end
