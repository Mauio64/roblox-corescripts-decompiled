local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Logging = require(ParentParentParent.AppCommonLib).Logging
local checkAndSendEvent = require(ParentParent.Utils.checkAndSendEvent)

return function(s1: string, s2: string?, b1: boolean?, s3: string?) -- line: 6
	-- upvalues: Logging (copy), checkAndSendEvent (copy)
	local t1 = {}

	if s2 then
		if type(s2) ~= "string" then
			Logging.warn("Failure logging authPageLoad: Expected state to be a string but got " .. type(s2))

			return
		end

		t1.state = s2
	end

	if b1 ~= nil then
		if type(b1) ~= "boolean" then
			Logging.warn("Failure logging authPageLoad: Expected isAltAttempt to be a boolean but got " .. type(b1))

			return
		end

		t1.is_alt_attempt = b1
	end

	if s3 then
		if type(s3) ~= "string" then
			Logging.warn("Failure logging authPageLoad: Expected origin to be a string but got " .. type(s3))

			return
		end

		t1.origin = s3
	end

	checkAndSendEvent(s1, "authPageload", t1)
end
