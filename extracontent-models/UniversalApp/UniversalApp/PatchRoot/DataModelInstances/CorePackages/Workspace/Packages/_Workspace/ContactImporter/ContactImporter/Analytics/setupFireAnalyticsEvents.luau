local ParentParent = script.Parent.Parent
local SocialLuaAnalytics = require(ParentParent.dependencies).SocialLuaAnalytics
local EventNames = require(script.Parent.Enums.EventNames)
local fireReportStats = require(script.Parent.fireReportStats)
local fireEventStream = SocialLuaAnalytics.Analytics.FireEvent.fireEventStream
local fireDiagCounter = SocialLuaAnalytics.Analytics.FireEvent.fireDiagCounter
local AnalyticsEvents = require(script.Parent.AnalyticsEvents)
local DiagEvents = require(script.Parent.DiagEvents)

return function(t1: {[any]: any}) -- line: 12
	-- upvalues: fireEventStream (copy), AnalyticsEvents (copy), fireDiagCounter (copy), DiagEvents (copy), fireReportStats (copy), EventNames (copy)
	local v10 = fireEventStream({
		eventStreamImpl = if not t1.analytics then t1.eventStreamImpl else t1.analytics.EventStream,
		eventList = AnalyticsEvents,
		infoForAllEvents = t1.defaultAnalyticsInfo
	})
	local v11 = fireDiagCounter({
		diagImpl = if not t1.analytics then t1.diag else t1.analytics.Diag,
		eventList = DiagEvents
	})
	local v12 = fireReportStats({
		diagImpl = if not t1.analytics then t1.diag else t1.analytics.Diag,
		eventList = DiagEvents
	})

	return function(p1, p2) -- line: 35
		-- upvalues: DiagEvents (copy), EventNames (copy), v12 (copy), v11 (copy), AnalyticsEvents (copy), v10 (copy)
		if DiagEvents[p1] then
			if p1 == EventNames.ContactImportingTime then
				v12(EventNames.ContactImportingTime, p2)
			else
				v11(p1)
			end
		end

		if AnalyticsEvents[p1] then
			v10(p1, p2)
		end
	end
end
