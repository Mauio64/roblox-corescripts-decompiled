local Parent = script:FindFirstAncestor("ProfileQRCode").Parent
local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local DiagActionList = require(script.Parent.DiagActionList)
local fireEventStream = SocialLuaAnalytics.Analytics.FireEvent.fireEventStream
local fireDiagCounter = SocialLuaAnalytics.Analytics.FireEvent.fireDiagCounter
local EventStreamActionList = require(script.Parent.EventStreamActionList)

return function(t1: {[any]: any}) -- line: 10
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
		-- upvalues: DiagActionList (copy), v9 (copy), v8 (copy)
		if DiagActionList[p1] then
			v9(p1)
		end

		return v8(p1, p2)
	end
end
