local AuthAnalytics = script:FindFirstAncestor("AuthAnalytics")
local checkAndSendEvent = require(AuthAnalytics.Utils.checkAndSendEvent)

return function(s1: string, n1: number, s2: string) -- line: 4
	-- upvalues: checkAndSendEvent (copy)
	local t1 = {
		elapsedTime = n1,
		state = s2
	}

	checkAndSendEvent(s1, "authOperationTiming", t1)
end
