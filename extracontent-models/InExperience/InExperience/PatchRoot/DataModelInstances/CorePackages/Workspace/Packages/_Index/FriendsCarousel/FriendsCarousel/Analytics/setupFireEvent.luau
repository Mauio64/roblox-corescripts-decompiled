local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local SocialLuaAnalytics = dependencies.SocialLuaAnalytics
local DiagActionList = require(script.Parent.DiagActionList)
local fireEventStream = SocialLuaAnalytics.Analytics.FireEvent.fireEventStream
local fireDiagCounter = SocialLuaAnalytics.Analytics.FireEvent.fireDiagCounter
local EventStreamActionList = require(script.Parent.EventStreamActionList)
local AnalyticsService = dependencies.AnalyticsService

return function(t1: {[any]: any}) -- line: 11
	-- upvalues: fireEventStream (copy), EventStreamActionList (copy), fireDiagCounter (copy), AnalyticsService (copy), DiagActionList (copy)
	local v10 = fireEventStream({
		eventStreamImpl = t1.analytics.EventStream,
		eventList = EventStreamActionList,
		infoForAllEvents = t1.infoForAllEvents
	})
	local v11 = fireDiagCounter({
		diagImpl = if t1.analytics.Diag then t1.analytics.Diag else AnalyticsService.Diag,
		eventList = DiagActionList
	})

	return function(p1, p2) -- line: 27
		-- upvalues: v11 (copy), DiagActionList (copy), v10 (copy)
		if v11 and DiagActionList[p1] then
			v11(p1)
		end

		return v10(p1, p2)
	end
end
