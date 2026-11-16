local HttpService = game:GetService("HttpService")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UrlBuilder").UrlBuilder
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Promise")

return function(callback, value, value2)
	if type(value) == "string" and type(value2) == "string" then
		local v5 = urlBuilder.fromString("apis:auth-token-service/v1/login/status")
		local jsonEncode = HttpService:JSONEncode({ code = value, privateKey = value2 })

		return callback(v5(), "POST", { postBody = jsonEncode })
	elseif type(value) == "string" then
		return Promise.reject("invalid private key")
	else
		return Promise.reject("invalid login code")
	end
end
