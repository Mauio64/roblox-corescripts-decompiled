local HttpService = game:GetService("HttpService")

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UrlBuilder").UrlBuilder
local UsernameValidationContext = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Enums/UsernameValidationContext")

return function(callback, value, value2, p2)
	local v5 = p2 or UsernameValidationContext.Unknown

	assert(type(value) == "string", "invalid username")
	assert(type(value2) == "string", "invalid birthday")

	local v6 = urlBuilder.fromString("auth:v2/usernames/validate")

	local jsonEncode = HttpService:JSONEncode({
		username = value,
		birthday = value2,
		context = v5
	})

	return callback(v6(), "POST", { postBody = jsonEncode })
end
