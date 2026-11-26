local HttpService = game:GetService("HttpService")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UrlBuilder").UrlBuilder

return function(callback, value)
	assert(type(value) == "string", "invalid login code")
	local v5 = urlBuilder.fromString("apis:auth-token-service/v1/login/cancel")
	local jsonEncode = HttpService:JSONEncode({ code = value })

	return callback(v5(), "POST", { postBody = jsonEncode })
end
