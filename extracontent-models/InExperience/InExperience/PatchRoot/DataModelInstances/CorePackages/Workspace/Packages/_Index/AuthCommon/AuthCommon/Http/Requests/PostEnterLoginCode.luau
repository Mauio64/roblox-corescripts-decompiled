local Parent = script:FindFirstAncestor("AuthCommon").Parent
local HttpService = game:GetService("HttpService")
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder

return function(p1, p2) -- line: 7
	-- upvalues: UrlBuilder (copy), HttpService (copy)
	assert(type(p2) == "string", "invalid login code")

	local v6 = UrlBuilder.fromString("apis:auth-token-service/v1/login/entercode")
	local json = HttpService:JSONEncode({
		code = p2
	})

	return p1(v6(), "POST", {
		postBody = json
	})
end
