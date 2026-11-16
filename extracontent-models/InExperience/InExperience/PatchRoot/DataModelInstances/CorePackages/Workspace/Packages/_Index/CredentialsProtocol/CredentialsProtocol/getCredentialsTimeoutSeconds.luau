local Constants = require(script.Parent.Constants)

local function getCredentialsTimeoutSeconds(value: number?)
	if typeof(value) == "number" and not (value <= 0) then
		return value / 1000
	end

	return Constants.Defaults.CREDENTIALSPROTOCOL_GETCREDENTIALS_DEFAULTTIMEOUT
end

return getCredentialsTimeoutSeconds
