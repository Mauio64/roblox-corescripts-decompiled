local parent = script.Parent.Parent
local parent2 = parent.Parent
local AppCommonLib = require(parent2.AppCommonLib)
local Logging = AppCommonLib.Logging
local checkAndSendEvent = require(parent.Utils.checkAndSendEvent)

return function(p: string, state: string?, is_alt_attempt: boolean?, origin: string?, value: string?, value2: string?)
	local v = {}

	if state then
		if type(state) == "string" then
			v.state = state
		else
			Logging.warn("Failure logging authPageLoad: Expected state to be a string but got " .. type(state))
			return
		end
	end

	if is_alt_attempt ~= nil then
		if type(is_alt_attempt) == "boolean" then
			v.is_alt_attempt = is_alt_attempt
		else
			Logging.warn("Failure logging authPageLoad: Expected isAltAttempt to be a boolean but got " .. type(is_alt_attempt))

			return
		end
	end

	if origin then
		if type(origin) == "string" then
			v.origin = origin
		else
			Logging.warn("Failure logging authPageLoad: Expected origin to be a string but got " .. type(origin))
			return
		end
	end

	if value ~= nil then
		if type(value) ~= "string" then
			Logging.warn("Failure logging authPageLoad: Expected field to be a string but got " .. type(value))
		end

		v.field = tostring(value)
	end

	if value2 ~= nil then
		if type(value2) ~= "string" then
			Logging.warn("Failure logging authPageLoad: Expected associatedText to be a string but got " .. type(value2))
		end

		v.associatedText = tostring(value2)
	end

	checkAndSendEvent(p, "authPageload", v)
end
