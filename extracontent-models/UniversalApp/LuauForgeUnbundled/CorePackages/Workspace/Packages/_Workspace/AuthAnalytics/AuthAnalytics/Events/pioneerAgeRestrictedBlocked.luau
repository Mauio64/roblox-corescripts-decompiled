local checkAndSendEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/AuthAnalytics/Utils/checkAndSendEvent")

return function(p2, p3)
	checkAndSendEvent(p2, "pioneerAgeRestrictedBlocked", { source = p3 })
end
