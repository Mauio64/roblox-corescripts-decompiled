local parent = script:FindFirstAncestor("AuthSignup").Parent

local HttpService = game:GetService("HttpService")
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

return function(callback, username, value)
	assert(type(username) == "string", "invalid username")
	assert(type(value) == "string", "invalid birthday")

	local v = urlBuilder.fromString("auth:v1/validators/username")

	local jsonEncode = HttpService:JSONEncode({ username = username, birthday = value })

	return callback(v(), "POST", { postBody = jsonEncode, maxRetryCount = 0 })
end
