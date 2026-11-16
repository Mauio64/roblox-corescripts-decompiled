local parent = script:FindFirstAncestor("ProfileQRCode").Parent
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)

local DiagActionList = require(script.Parent.DiagActionList)
local fireEventStream = SocialLuaAnalytics.Analytics.FireEvent.fireEventStream
local fireDiagCounter = SocialLuaAnalytics.Analytics.FireEvent.fireDiagCounter
local EventStreamActionList = require(script.Parent.EventStreamActionList)

return function(p)
	local v = fireEventStream({
		eventStreamImpl = p.analytics.EventStream,
		eventList = EventStreamActionList,
		infoForAllEvents = p.infoForAllEvents
	})

	local v2 = fireDiagCounter({ diagImpl = p.analytics.Diag, eventList = DiagActionList })

	return function(p2, p3)
		if DiagActionList[p2] then
			v2(p2)
		end

		return v(p2, p3)
	end
end
