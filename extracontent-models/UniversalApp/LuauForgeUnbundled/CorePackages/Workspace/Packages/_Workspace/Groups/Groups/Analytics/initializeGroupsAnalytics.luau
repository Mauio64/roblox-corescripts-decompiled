local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/SocialLuaAnalytics")
local analyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local defaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService

local EventStreamActionList = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Analytics/EventStreamActionList")

return analyticsFactory.setUpAnalyticsFactory({
	eventLists = { EventStream = EventStreamActionList },
	analyticsImpl = { EventStream = defaultAnalyticsService.EventStream }
})
