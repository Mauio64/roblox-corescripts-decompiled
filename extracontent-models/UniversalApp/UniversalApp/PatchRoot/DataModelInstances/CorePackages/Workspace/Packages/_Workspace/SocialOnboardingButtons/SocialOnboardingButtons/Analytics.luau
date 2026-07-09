local Parent = script:FindFirstAncestor("SocialOnboardingButtons").Parent
local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local AnalyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local DefaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService
local getEventStreamActionList = require(script.getEventStreamActionList)
local DiagActionList = require(script.DiagActionList)

return {
	EventNames = require(script.EventNames),
	getAnalytics = function(s1: string) -- line: 14
		-- upvalues: getEventStreamActionList (copy), AnalyticsFactory (copy), DiagActionList (copy), DefaultAnalyticsService (copy)
		local v8 = getEventStreamActionList(s1)

		return AnalyticsFactory.setUpAnalyticsFactory({
			eventLists = {
				EventStream = v8,
				Diag = DiagActionList
			},
			analyticsImpl = {
				EventStream = DefaultAnalyticsService.EventStream,
				Diag = DefaultAnalyticsService.Diag
			}
		})
	end
}
