local logging = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/AppCommonLib").Logging
local checkAndSendEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/AuthAnalytics/Utils/checkAndSendEvent")

return function(p2, state, is_alt_attempt, origin, value, value2)
	local v5 = {}

	if state then
		if type(state) == "string" then
			v5.state = state
		else
			logging.warn("Failure logging authPageLoad: Expected state to be a string but got " .. type(state))
			return
		end
	end

	if is_alt_attempt ~= nil then
		if type(is_alt_attempt) == "boolean" then
			v5.is_alt_attempt = is_alt_attempt
		else
			logging.warn("Failure logging authPageLoad: Expected isAltAttempt to be a boolean but got " .. type(is_alt_attempt))

			return
		end
	end

	if origin then
		if type(origin) == "string" then
			v5.origin = origin
		else
			logging.warn("Failure logging authPageLoad: Expected origin to be a string but got " .. type(origin))
			return
		end
	end

	if value ~= nil then
		if type(value) ~= "string" then
			logging.warn("Failure logging authPageLoad: Expected field to be a string but got " .. type(value))
		end

		v5.field = tostring(value)
	end

	if value2 ~= nil then
		if type(value2) ~= "string" then
			logging.warn("Failure logging authPageLoad: Expected associatedText to be a string but got " .. type(value2))
		end

		v5.associatedText = tostring(value2)
	end

	checkAndSendEvent(p2, "authPageload", v5)
end
