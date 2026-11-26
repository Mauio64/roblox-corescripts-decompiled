local checkAndSendEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/AuthAnalytics/Utils/checkAndSendEvent")

return function(p2, state, field, errorCode, associatedText)
	local v5 = {}

	if state then
		v5.state = state
	end

	if field then
		v5.field = field
	end

	if errorCode then
		v5.errorCode = errorCode
	end

	if associatedText then
		v5.associatedText = associatedText
	end

	checkAndSendEvent(p2, "authMsgShown", v5)
end
