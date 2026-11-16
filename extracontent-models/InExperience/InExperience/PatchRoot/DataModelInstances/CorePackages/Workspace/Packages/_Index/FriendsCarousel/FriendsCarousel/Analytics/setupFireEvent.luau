local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)
local socialLuaAnalytics = dependencies.SocialLuaAnalytics

local DiagActionList = require(script.Parent.DiagActionList)
local fireEventStream = socialLuaAnalytics.Analytics.FireEvent.fireEventStream
local fireDiagCounter = socialLuaAnalytics.Analytics.FireEvent.fireDiagCounter
local EventStreamActionList = require(script.Parent.EventStreamActionList)
local analyticsService = dependencies.AnalyticsService

return function(p)
	local v = fireEventStream({
		eventStreamImpl = p.analytics.EventStream,
		eventList = EventStreamActionList,
		infoForAllEvents = p.infoForAllEvents
	})
	local diagImpl

	if p.analytics.Diag then
		diagImpl = p.analytics.Diag
	else
		diagImpl = analyticsService.Diag
	end

	local v2 = fireDiagCounter({ diagImpl = diagImpl, eventList = DiagActionList })

	return function(p2, p3)
		if v2 and DiagActionList[p2] then
			v2(p2)
		end

		return v(p2, p3)
	end
end
