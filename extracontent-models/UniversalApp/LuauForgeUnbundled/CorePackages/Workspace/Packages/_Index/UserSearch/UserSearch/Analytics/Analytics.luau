local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SocialLuaAnalytics")

local analyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local defaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService

local EventStreamActionList = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Analytics/EventStreamActionList")
local DiagEventsList = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Analytics/DiagEventsList")

return analyticsFactory.setUpAnalyticsFactory({
	eventLists = { EventStream = EventStreamActionList, Diag = DiagEventsList },
	analyticsImpl = {
		EventStream = defaultAnalyticsService.EventStream,
		Diag = defaultAnalyticsService.Diag
	}
})
