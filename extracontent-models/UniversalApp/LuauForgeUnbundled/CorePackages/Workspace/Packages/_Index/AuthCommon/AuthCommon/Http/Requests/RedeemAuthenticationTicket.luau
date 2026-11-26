local HttpService = game:GetService("HttpService")

local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Http")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags")
local AppStorageUtilities = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/AppStorageUtilities")

local fFlagEnableLuaAccountSwitch = SharedFlags.FFlagEnableLuaAccountSwitch

return function(callback, p2)
	local jsonEncode = HttpService:JSONEncode({
		authenticationTicket = p2,
		retainCurrentSession = true,
		accountBlob = fFlagEnableLuaAccountSwitch and AppStorageUtilities.getAccountBlob() or nil
	})

	return (callback(string.format("%sv1/authentication-ticket/redeem", Http.Url.AUTH_URL), "POST", {
		postBody = jsonEncode
	}))
end
