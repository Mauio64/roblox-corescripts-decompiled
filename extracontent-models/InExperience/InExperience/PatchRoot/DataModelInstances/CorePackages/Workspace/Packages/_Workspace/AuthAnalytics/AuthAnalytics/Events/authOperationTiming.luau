local AuthAnalytics = script:FindFirstAncestor("AuthAnalytics")
local checkAndSendEvent = require(AuthAnalytics.Utils.checkAndSendEvent)

return function(p: string, elapsedTime: number, state: string)
	checkAndSendEvent(p, "authOperationTiming", { elapsedTime = elapsedTime, state = state })
end
