local ParentParent = script.Parent.Parent
local SocialLuaAnalytics = require(ParentParent.dependencies).SocialLuaAnalytics
local DiagEvents = require(script.Parent.DiagEvents)
local fireEventStream = SocialLuaAnalytics.Analytics.FireEvent.fireEventStream
local fireDiagCounter = SocialLuaAnalytics.Analytics.FireEvent.fireDiagCounter
local AnalyticsEvents = require(script.Parent.AnalyticsEvents)

return function(t1: {[any]: any}) -- line: 10
	-- upvalues: fireEventStream (copy), AnalyticsEvents (copy), fireDiagCounter (copy), DiagEvents (copy)
	local v8 = fireEventStream({
		eventStreamImpl = if not t1.analytics then t1.eventStreamImpl else t1.analytics.EventStream,
		eventList = AnalyticsEvents,
		infoForAllEvents = t1.defaultAnalyticsInfo
	})
	local v9 = fireDiagCounter({
		diagImpl = if not t1.analytics then t1.diag else t1.analytics.Diag,
		eventList = DiagEvents
	})

	return function(p1, p2) -- line: 28
		-- upvalues: v9 (copy), v8 (copy)
		v9(p1)
		v8(p1, p2)
	end
end
