local Parent = script:FindFirstAncestor("AuthCommon").Parent
local HttpService = game:GetService("HttpService")
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder

return function(p1, p2, p3) -- line: 10
	-- upvalues: UrlBuilder (copy), HttpService (copy)
	assert(type(p2) == "string", "invalid username")
	assert(type(p3) == "string", "invalid password")

	local v7 = UrlBuilder.fromString("auth:v2/passwords/validate")
	local json = HttpService:JSONEncode({
		username = p2,
		password = p3
	})

	return p1(v7(), "POST", {
		postBody = json
	})
end
