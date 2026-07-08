local CorePackages = game:GetService("CorePackages")
local SocialLuaAnalytics = require(CorePackages.Workspace.Packages.SocialLuaAnalytics)
local AnalyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local DefaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService
local EventStreamActionList = require(script.EventStreamActionList)

return {
	Analytics = AnalyticsFactory.setUpAnalyticsFactory({
		eventLists = {
			Diag = nil,
			EventStream = EventStreamActionList
		},
		analyticsImpl = {
			Diag = nil,
			EventStream = DefaultAnalyticsService.EventStream
		}
	}),
	useAnalytics = require(script.useAnalytics)
}
