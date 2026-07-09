local Parent = script:FindFirstAncestor("FriendsCarousel").Parent
local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local AnalyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local DefaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService
local EventStreamActionList = require(script.Parent.EventStreamActionList)
local DiagActionList = require(script.Parent.DiagActionList)

return AnalyticsFactory.setUpAnalyticsFactory({
	eventLists = {
		EventStream = EventStreamActionList,
		Diag = DiagActionList
	},
	analyticsImpl = {
		EventStream = DefaultAnalyticsService.EventStream,
		Diag = DefaultAnalyticsService.Diag
	}
})
