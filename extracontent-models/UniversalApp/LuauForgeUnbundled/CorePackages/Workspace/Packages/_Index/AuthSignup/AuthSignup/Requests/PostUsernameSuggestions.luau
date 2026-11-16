local HttpService = game:GetService("HttpService")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/UrlBuilder").UrlBuilder

return function(callback, value, value2)
	assert(type(value) == "string", "invalid username")
	assert(type(value2) == "string", "invalid birthday")

	local v5 = urlBuilder.fromString("auth:v1/validators/username")

	local jsonEncode = HttpService:JSONEncode({ username = value, birthday = value2 })

	return callback(v5(), "POST", { postBody = jsonEncode, maxRetryCount = 0 })
end
