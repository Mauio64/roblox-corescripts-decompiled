local socialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies").SocialLuaAnalytics

local DiagActionList = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Analytics/DiagActionList")
local EventStreamActionList = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Analytics/EventStreamActionList")
return socialLuaAnalytics.Analytics.FireEvent.createFireEvent({
	EventStream = EventStreamActionList,
	Diag = DiagActionList
})
