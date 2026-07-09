local Parent = script:FindFirstAncestor("Groups").Parent
local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local AnalyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local DefaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService
local EventStreamActionList = require(script.Parent.EventStreamActionList)

return AnalyticsFactory.setUpAnalyticsFactory({
	eventLists = {
		EventStream = EventStreamActionList
	},
	analyticsImpl = {
		EventStream = DefaultAnalyticsService.EventStream
	}
})
