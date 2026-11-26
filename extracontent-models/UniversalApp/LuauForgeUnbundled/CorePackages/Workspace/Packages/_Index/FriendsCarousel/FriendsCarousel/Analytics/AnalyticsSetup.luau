local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/SocialLuaAnalytics")
local analyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local defaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService

local EventStreamActionList = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/Analytics/EventStreamActionList")
local DiagActionList = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/Analytics/DiagActionList")

return analyticsFactory.setUpAnalyticsFactory({
	eventLists = { EventStream = EventStreamActionList, Diag = DiagActionList },
	analyticsImpl = {
		EventStream = defaultAnalyticsService.EventStream,
		Diag = defaultAnalyticsService.Diag
	}
})
