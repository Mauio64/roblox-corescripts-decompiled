local HttpService = game:GetService("HttpService")

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UrlBuilder").UrlBuilder

return function(callback)
	local v5 = urlBuilder.fromString("auth:/v1/logoutfromallsessionsandreauthenticate")
	local jsonEncode = HttpService:JSONEncode({
		SecureAuthenticationIntent = {
			clientPublicKey = "",
			clientEpochTimestamp = "",
			saiSignature = "",
			serverNonce = ""
		}
	})

	return callback(v5(), "POST", { postBody = jsonEncode })
end
