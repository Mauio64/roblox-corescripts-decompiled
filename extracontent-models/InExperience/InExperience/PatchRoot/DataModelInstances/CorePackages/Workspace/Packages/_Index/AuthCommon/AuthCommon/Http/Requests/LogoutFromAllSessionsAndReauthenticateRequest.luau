local parent = script:FindFirstAncestor("AuthCommon").Parent

local HttpService = game:GetService("HttpService")

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

return function(callback)
	local v = urlBuilder.fromString("auth:/v1/logoutfromallsessionsandreauthenticate")
	local jsonEncode = HttpService:JSONEncode({
		SecureAuthenticationIntent = {
			clientPublicKey = "",
			clientEpochTimestamp = "",
			saiSignature = "",
			serverNonce = ""
		}
	})

	return callback(v(), "POST", { postBody = jsonEncode })
end
