local parent = script:FindFirstAncestor("AuthCommon").Parent

local HttpService = game:GetService("HttpService")
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local Promise = require(parent.Promise)

return function(callback, code, value)
	if type(code) == "string" and type(value) == "string" then
		local v = urlBuilder.fromString("apis:auth-token-service/v1/login/status")
		local jsonEncode = HttpService:JSONEncode({ code = code, privateKey = value })

		return callback(v(), "POST", { postBody = jsonEncode })
	elseif type(code) == "string" then
		return Promise.reject("invalid private key")
	else
		return Promise.reject("invalid login code")
	end
end
