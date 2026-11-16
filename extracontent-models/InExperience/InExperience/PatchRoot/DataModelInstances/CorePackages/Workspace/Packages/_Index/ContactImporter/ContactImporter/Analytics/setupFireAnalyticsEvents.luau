local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)
local socialLuaAnalytics = dependencies.SocialLuaAnalytics

local EventNames = require(script.Parent.Enums.EventNames)
local fireReportStats = require(script.Parent.fireReportStats)
local fireEventStream = socialLuaAnalytics.Analytics.FireEvent.fireEventStream
local fireDiagCounter = socialLuaAnalytics.Analytics.FireEvent.fireDiagCounter
local AnalyticsEvents = require(script.Parent.AnalyticsEvents)
local DiagEvents = require(script.Parent.DiagEvents)

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
	local diagImpl2

	if data.analytics then
		diagImpl2 = data.analytics.Diag
	else
		diagImpl2 = data.diag
	end

	local v3 = fireReportStats({ diagImpl = diagImpl2, eventList = DiagEvents })

	return function(p, p2)
		if DiagEvents[p] then
			if p == EventNames.ContactImportingTime then
				v3(EventNames.ContactImportingTime, p2)
			else
				v2(p)
			end
		end

		if AnalyticsEvents[p] then
			v(p, p2)
		end
	end
end
