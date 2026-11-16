local AuthCommon = script:FindFirstAncestor("AuthCommon")
local HttpService = game:GetService("HttpService")
local parent = AuthCommon.Parent
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local UsernameValidationContext = require(AuthCommon.Enums.UsernameValidationContext)

return function(callback, username, value, p)
	local context = p or UsernameValidationContext.Unknown

	assert(type(username) == "string", "invalid username")
	assert(type(value) == "string", "invalid birthday")

	local v = urlBuilder.fromString("auth:v2/usernames/validate")

	local jsonEncode = HttpService:JSONEncode({
		username = username,
		birthday = value,
		context = context
	})

	return callback(v(), "POST", { postBody = jsonEncode })
end
