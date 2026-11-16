local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactAnalytics = RoactServiceTags.RoactAnalytics

local RoactServiceTags2 = require(parent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags2.AppEventIngestService

local UnifiedLogging = require(parent.UnifiedLogging)
local SendItemImpressions = UnifiedLogging.SendItemImpressions

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)

local EventNames = require(ProfilePlatform.Analytics.EventNames)

return function(p, p2: number, p3: string, p4: number, component: string)
	local v = useRoactService(AppEventIngestService)
	local v2 = useRoactService(RoactAnalytics)
	local profilePlatform = AppPage.ProfilePlatform
	local v3 = useProfileAnalyticsContext()

	return React.useCallback(function(p5)
		v3.fireAnalyticsEvent(EventNames.ProfileImpressionsSent, { component = component })

		if SendItemImpressions and SendItemImpressions.sendFromProfile then
			SendItemImpressions.sendFromProfile(v, v2, p5, p, p2, profilePlatform, p3, p4, component)
		end
	end, {
		v2,
		p4,
		component,
		p3,
		v,
		profilePlatform,
		p,
		p2,
		SendItemImpressions
	})
end
