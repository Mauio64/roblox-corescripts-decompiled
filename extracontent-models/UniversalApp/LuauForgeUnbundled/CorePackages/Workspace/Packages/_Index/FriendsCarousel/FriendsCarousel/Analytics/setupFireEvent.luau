local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/dependencies")
local socialLuaAnalytics = dependencies.SocialLuaAnalytics

local DiagActionList = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/Analytics/DiagActionList")
local fireEventStream = socialLuaAnalytics.Analytics.FireEvent.fireEventStream
local fireDiagCounter = socialLuaAnalytics.Analytics.FireEvent.fireDiagCounter
local EventStreamActionList = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/Analytics/EventStreamActionList")
local analyticsService = dependencies.AnalyticsService

return function(p2)
	local v5 = fireEventStream({
		eventStreamImpl = p2.analytics.EventStream,
		eventList = EventStreamActionList,
		infoForAllEvents = p2.infoForAllEvents
	})

	local v8 = if p2.analytics.Diag then p2.analytics.Diag else analyticsService.Diag
	local v9 = fireDiagCounter({ diagImpl = v8, eventList = DiagActionList })

	return function(p3, p4)
		if v9 and DiagActionList[p3] then
			v9(p3)
		end

		return v5(p3, p4)
	end
end
