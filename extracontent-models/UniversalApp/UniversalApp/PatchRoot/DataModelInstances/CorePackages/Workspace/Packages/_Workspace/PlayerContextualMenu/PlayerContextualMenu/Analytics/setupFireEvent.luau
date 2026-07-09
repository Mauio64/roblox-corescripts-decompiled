local ParentParent = script.Parent.Parent.Parent
local SocialLuaAnalytics = require(ParentParent.SocialLuaAnalytics)
local fireDiagCounter = SocialLuaAnalytics.Analytics.FireEvent.fireDiagCounter
local fireEventStream = SocialLuaAnalytics.Analytics.FireEvent.fireEventStream
local EventStreamActionList = require(script.Parent.EventStreamActionList)
local DiagActionList = require(script.Parent.DiagActionList)

return function(t1: {[any]: any}) -- line: 11
	-- upvalues: fireEventStream (copy), EventStreamActionList (copy), fireDiagCounter (copy), DiagActionList (copy)
	local v8 = fireEventStream({
		eventStreamImpl = t1.analytics.EventStream,
		eventList = EventStreamActionList,
		infoForAllEvents = t1.infoForAllEvents
	})
	local v9 = fireDiagCounter({
		diagImpl = t1.analytics.Diag,
		eventList = DiagActionList
	})

	return function(p1, p2) -- line: 26
		-- upvalues: v9 (copy), DiagActionList (copy), v8 (copy)
		if v9 and DiagActionList[p1] then
			v9(p1)
		end

		return v8(p1, p2)
	end
end
