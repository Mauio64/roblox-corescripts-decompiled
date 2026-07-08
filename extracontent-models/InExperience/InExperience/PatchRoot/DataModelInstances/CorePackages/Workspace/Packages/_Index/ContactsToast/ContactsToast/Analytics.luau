local Parent = script:FindFirstAncestor("ContactsToast").Parent
local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local AnalyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local DefaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService
local EventStreamActionList = require(script.EventStreamActionList)
local DiagActionList = require(script.DiagActionList)

return {
	EventNames = require(script.EventNames),
	Analytics = AnalyticsFactory.setUpAnalyticsFactory({
		eventLists = {
			EventStream = EventStreamActionList,
			Diag = DiagActionList
		},
		analyticsImpl = {
			EventStream = DefaultAnalyticsService.EventStream,
			Diag = DefaultAnalyticsService.Diag
		}
	})
}
