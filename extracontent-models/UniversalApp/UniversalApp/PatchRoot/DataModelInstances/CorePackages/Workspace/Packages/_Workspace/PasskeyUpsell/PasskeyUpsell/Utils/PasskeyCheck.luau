local Parent = script:FindFirstAncestor("PasskeyUpsell").Parent
local Promise = require(Parent.Promise)
local Url = require(Parent.Http).Url
local Logger = require(Parent.Loggers).Logger

local function getListCredentialsUrl() -- line: 7
	-- upvalues: Url (copy)
	return string.format("%sv1/passkey/ListCredentials", Url.AUTH_URL)
end
local function listCredentials(p1) -- line: 17
	-- upvalues: Url (copy), Promise (copy)
	return p1(string.format("%sv1/passkey/ListCredentials", Url.AUTH_URL), "POST"):andThen(function(p2) -- line: 18
		-- upvalues: Promise (copy)
		return Promise.resolve(p2[1])
	end)
end
local function hasPasskey(p3) -- line: 29
	-- upvalues: Url (copy), Promise (copy), Logger (copy)
	return p3(string.format("%sv1/passkey/ListCredentials", Url.AUTH_URL), "POST"):andThen(function(p4) -- line: 18
		-- upvalues: Promise (copy)
		return Promise.resolve(p4[1])
	end):andThen(function(p5) -- line: 31
		-- upvalues: Logger (copy)
		if p5 and p5.credentials then
			Logger:info("User has {} existing passkey credentials.", #p5.credentials)

			return #p5.credentials > 0
		end

		Logger:info("User does NOT have existing passkey credentials.")

		return false
	end):catch(function(p6) -- line: 40
		-- upvalues: Logger (copy)
		Logger:debug("Error checking if user has passkey: {}", p6)

		return true
	end)
end

return hasPasskey
