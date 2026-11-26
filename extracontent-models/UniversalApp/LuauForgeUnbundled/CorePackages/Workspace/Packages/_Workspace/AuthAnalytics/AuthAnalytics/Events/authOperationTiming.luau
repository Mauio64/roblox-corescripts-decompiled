local checkAndSendEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/AuthAnalytics/Utils/checkAndSendEvent")

return function(p2, p3, p4)
	checkAndSendEvent(p2, "authOperationTiming", { elapsedTime = p3, state = p4 })
end
