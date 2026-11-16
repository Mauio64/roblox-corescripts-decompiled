local parent = script.Parent.Parent.Parent

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local fireDiagCounter = SocialLuaAnalytics.Analytics.FireEvent.fireDiagCounter
local fireEventStream = SocialLuaAnalytics.Analytics.FireEvent.fireEventStream

local EventStreamActionList = require(script.Parent.EventStreamActionList)
local DiagActionList = require(script.Parent.DiagActionList)

return function(p)
	local v = fireEventStream({
		eventStreamImpl = p.analytics.EventStream,
		eventList = EventStreamActionList,
		infoForAllEvents = p.infoForAllEvents
	})

	local v2 = fireDiagCounter({ diagImpl = p.analytics.Diag, eventList = DiagActionList })

	return function(p2, p3)
		if v2 and DiagActionList[p2] then
			v2(p2)
		end

		return v(p2, p3)
	end
end
