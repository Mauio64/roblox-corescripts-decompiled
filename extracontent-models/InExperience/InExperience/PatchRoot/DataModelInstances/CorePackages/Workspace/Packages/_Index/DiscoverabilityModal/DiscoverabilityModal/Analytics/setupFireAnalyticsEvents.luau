local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)
local socialLuaAnalytics = dependencies.SocialLuaAnalytics

local DiagEvents = require(script.Parent.DiagEvents)
local fireEventStream = socialLuaAnalytics.Analytics.FireEvent.fireEventStream
local fireDiagCounter = socialLuaAnalytics.Analytics.FireEvent.fireDiagCounter
local AnalyticsEvents = require(script.Parent.AnalyticsEvents)

return function(data)
	local eventStreamImpl

	if data.analytics then
		eventStreamImpl = data.analytics.EventStream
	else
		eventStreamImpl = data.eventStreamImpl
	end

	local v = fireEventStream({
		eventStreamImpl = eventStreamImpl,
		eventList = AnalyticsEvents,
		infoForAllEvents = data.defaultAnalyticsInfo
	})
	local diagImpl

	if data.analytics then
		diagImpl = data.analytics.Diag
	else
		diagImpl = data.diag
	end

	local v2 = fireDiagCounter({ diagImpl = diagImpl, eventList = DiagEvents })

	return function(p, p2)
		v2(p)
		v(p, p2)
	end
end
