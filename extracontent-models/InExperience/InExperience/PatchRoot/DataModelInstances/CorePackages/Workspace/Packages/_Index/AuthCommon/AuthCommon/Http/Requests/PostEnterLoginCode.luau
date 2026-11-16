local parent = script:FindFirstAncestor("AuthCommon").Parent

local HttpService = game:GetService("HttpService")
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

return function(callback, code)
	assert(type(code) == "string", "invalid login code")
	local v = urlBuilder.fromString("apis:auth-token-service/v1/login/entercode")
	local jsonEncode = HttpService:JSONEncode({ code = code })

	return callback(v(), "POST", { postBody = jsonEncode })
end
