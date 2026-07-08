local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local useRoactService = require(ProfilePlatformParent.RobloxAppHooks).useRoactService
local RoactAnalytics = require(ProfilePlatformParent.RoactServiceTags).RoactAnalytics
local AppEventIngestService = require(ProfilePlatformParent.RoactServiceTags).AppEventIngestService
local SendItemImpressions = require(ProfilePlatformParent.UnifiedLogging).SendItemImpressions
local AppPage = require(ProfilePlatformParent.RobloxAppEnums).AppPage
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local EventNames = require(ProfilePlatform.Analytics.EventNames)

return function(t1: {[any]: any}, n1: number, s1: string, n2: number, s2: string) -- line: 19
	-- upvalues: useRoactService (copy), AppEventIngestService (copy), RoactAnalytics (copy), AppPage (copy), useProfileAnalyticsContext (copy), React (copy), EventNames (copy), SendItemImpressions (copy)
	local v16 = useRoactService(AppEventIngestService)
	local v17 = useRoactService(RoactAnalytics)
	local ProfilePlatform2 = AppPage.ProfilePlatform
	local v19 = useProfileAnalyticsContext()

	return React.useCallback(function(p1) -- line: 31
		-- upvalues: v19 (copy), EventNames (copy), s2 (copy), SendItemImpressions (copy), v16 (copy), v17 (copy), t1 (copy), n1 (copy), ProfilePlatform2 (copy), s1 (copy), n2 (copy)
		v19.fireAnalyticsEvent(EventNames.ProfileImpressionsSent, {
			component = s2
		})

		if SendItemImpressions and SendItemImpressions.sendFromProfile then
			SendItemImpressions.sendFromProfile(v16, v17, p1, t1, n1, ProfilePlatform2, s1, n2, s2)
		end
	end, {
		v17,
		n2,
		s2,
		s1,
		v16,
		ProfilePlatform2,
		t1,
		n1,
		SendItemImpressions
	})
end
