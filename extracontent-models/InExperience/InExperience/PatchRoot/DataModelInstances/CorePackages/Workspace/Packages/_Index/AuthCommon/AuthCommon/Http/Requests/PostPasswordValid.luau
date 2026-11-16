local parent = script:FindFirstAncestor("AuthCommon").Parent
local HttpService = game:GetService("HttpService")
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

return function(callback, username, value)
	assert(type(username) == "string", "invalid username")
	assert(type(value) == "string", "invalid password")

	local v = urlBuilder.fromString("auth:v2/passwords/validate")

	local jsonEncode = HttpService:JSONEncode({ username = username, password = value })

	return callback(v(), "POST", { postBody = jsonEncode })
end
