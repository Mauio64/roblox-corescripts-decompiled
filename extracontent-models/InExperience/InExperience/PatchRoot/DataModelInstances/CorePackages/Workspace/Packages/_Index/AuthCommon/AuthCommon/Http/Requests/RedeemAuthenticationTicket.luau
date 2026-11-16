local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local HttpService = game:GetService("HttpService")

local Http = require(parent.Http)
local SharedFlags = require(parent.SharedFlags)
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)

local FFlagEnableLuaAccountSwitch = SharedFlags.FFlagEnableLuaAccountSwitch

return function(callback, authenticationTicket: string)
	local jsonEncode = HttpService:JSONEncode({
		authenticationTicket = authenticationTicket,
		retainCurrentSession = true,
		accountBlob = FFlagEnableLuaAccountSwitch and AppStorageUtilities.getAccountBlob() or nil
	})

	return (callback(string.format("%sv1/authentication-ticket/redeem", Http.Url.AUTH_URL), "POST", {
		postBody = jsonEncode
	}))
end
