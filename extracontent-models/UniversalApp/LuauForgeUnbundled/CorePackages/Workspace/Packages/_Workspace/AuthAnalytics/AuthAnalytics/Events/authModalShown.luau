local logging = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/AppCommonLib").Logging
local checkAndSendEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/AuthAnalytics/Utils/checkAndSendEvent")

return function(p2, state, field, origin, associatedText, value)
	local v5 = {}

	if state then
		v5.state = state
	end

	if field then
		v5.field = field
	end

	if origin then
		v5.origin = origin
	end

	if associatedText then
		v5.associatedText = associatedText
	end

	if value ~= nil then
		if type(value) ~= "string" then
			logging.warn("Failure logging authModalShown: Expected errorCode to be a string but got " .. type(value))
		end

		v5.errorCode = tostring(value)
	end

	checkAndSendEvent(p2, "authModalShown", v5)
end
