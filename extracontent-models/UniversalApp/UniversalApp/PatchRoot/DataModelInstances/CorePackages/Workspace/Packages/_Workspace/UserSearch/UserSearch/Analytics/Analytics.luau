local Parent = script:FindFirstAncestor("UserSearch").Parent
local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local AnalyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local DefaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService
local EventStreamActionList = require(script.Parent.EventStreamActionList)
local DiagEventsList = require(script.Parent.DiagEventsList)

return AnalyticsFactory.setUpAnalyticsFactory({
	eventLists = {
		EventStream = EventStreamActionList,
		Diag = DiagEventsList
	},
	analyticsImpl = {
		EventStream = DefaultAnalyticsService.EventStream,
		Diag = DefaultAnalyticsService.Diag
	}
})
