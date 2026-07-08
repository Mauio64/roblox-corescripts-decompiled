local Parent = script:FindFirstAncestor("AuthCommon").Parent
local HttpService = game:GetService("HttpService")
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder

return function(p1) -- line: 8
	-- upvalues: UrlBuilder (copy), HttpService (copy)
	local v5 = UrlBuilder.fromString("auth:/v1/logoutfromallsessionsandreauthenticate")
	local json = HttpService:JSONEncode({
		SecureAuthenticationIntent = {
			clientPublicKey = "",
			clientEpochTimestamp = "",
			saiSignature = "",
			serverNonce = ""
		}
	})

	return p1(v5(), "POST", {
		postBody = json
	})
end
