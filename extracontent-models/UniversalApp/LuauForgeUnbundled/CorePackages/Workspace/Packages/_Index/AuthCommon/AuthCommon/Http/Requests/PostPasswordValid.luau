local HttpService = game:GetService("HttpService")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UrlBuilder").UrlBuilder

return function(callback, value, value2)
	assert(type(value) == "string", "invalid username")
	assert(type(value2) == "string", "invalid password")

	local v5 = urlBuilder.fromString("auth:v2/passwords/validate")

	local jsonEncode = HttpService:JSONEncode({ username = value, password = value2 })

	return callback(v5(), "POST", { postBody = jsonEncode })
end
