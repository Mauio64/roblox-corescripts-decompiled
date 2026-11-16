local module = require("@luauforge/bundled/fEn")
local url = require("@luauforge/bundled/fEs").Url
local logger = require("@luauforge/bundled/fEo").Logger

local function getListCredentialsUrl()
	return string.format("%sv1/passkey/ListCredentials", url.AUTH_URL)
end

local function listCredentials(callback)
	return callback(string.format("%sv1/passkey/ListCredentials", url.AUTH_URL), "POST"):andThen(function(list)
		return module.resolve(list[1])
	end)
end

local function hasPasskey(callback)
	return callback(string.format("%sv1/passkey/ListCredentials", url.AUTH_URL), "POST"):andThen(function(list)
		return module.resolve(list[1])
	end):andThen(function(p2): boolean
		if p2 and p2.credentials then
			logger:info("User has {} existing passkey credentials.", #p2.credentials)
			return #p2.credentials > 0
		end

		logger:info("User does NOT have existing passkey credentials.")
		return false
	end):catch(function(p2): boolean
		logger:debug("Error checking if user has passkey: {}", p2)

		return true
	end)
end

return hasPasskey
