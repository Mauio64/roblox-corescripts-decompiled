local checkAndSendEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/AuthAnalytics/Utils/checkAndSendEvent")

return function(p2, p3, state, origin)
	local v5 = { btn = p3 }

	if state then
		v5.state = state
	end

	if origin then
		v5.origin = origin
	end

	checkAndSendEvent(p2, "authButtonShown", v5)
end
