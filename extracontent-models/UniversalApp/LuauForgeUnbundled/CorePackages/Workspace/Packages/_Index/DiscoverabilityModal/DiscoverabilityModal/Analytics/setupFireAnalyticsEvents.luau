local socialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/dependencies").SocialLuaAnalytics

local DiagEvents = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/Analytics/DiagEvents")
local fireEventStream = socialLuaAnalytics.Analytics.FireEvent.fireEventStream
local fireDiagCounter = socialLuaAnalytics.Analytics.FireEvent.fireDiagCounter
local AnalyticsEvents = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/Analytics/AnalyticsEvents")

return function(data)
	local v7 = if data.analytics then data.analytics.EventStream else data.eventStreamImpl
	local v8 = fireEventStream({
		eventStreamImpl = v7,
		eventList = AnalyticsEvents,
		infoForAllEvents = data.defaultAnalyticsInfo
	})

	local v11 = if data.analytics then data.analytics.Diag else data.diag
	local v12 = fireDiagCounter({ diagImpl = v11, eventList = DiagEvents })

	return function(p2, p3)
		v12(p2)
		v8(p2, p3)
	end
end
