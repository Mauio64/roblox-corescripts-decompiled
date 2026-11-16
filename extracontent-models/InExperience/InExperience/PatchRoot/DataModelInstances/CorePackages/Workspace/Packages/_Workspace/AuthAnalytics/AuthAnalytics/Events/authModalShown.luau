local parent = script.Parent.Parent
local parent2 = parent.Parent
local AppCommonLib = require(parent2.AppCommonLib)
local Logging = AppCommonLib.Logging
local checkAndSendEvent = require(parent.Utils.checkAndSendEvent)

return function(p: string, state: string?, field: string?, origin: string?, associatedText: string?, value: string?)
	local v = {}

	if state then
		v.state = state
	end

	if field then
		v.field = field
	end

	if origin then
		v.origin = origin
	end

	if associatedText then
		v.associatedText = associatedText
	end

	if value ~= nil then
		if type(value) ~= "string" then
			Logging.warn("Failure logging authModalShown: Expected errorCode to be a string but got " .. type(value))
		end

		v.errorCode = tostring(value)
	end

	checkAndSendEvent(p, "authModalShown", v)
end
