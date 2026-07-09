local Parent = script:FindFirstAncestor("AuthSignup").Parent
local HttpService = game:GetService("HttpService")
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder

return function(p1, p2, p3) -- line: 12
	-- upvalues: UrlBuilder (copy), HttpService (copy)
	assert(type(p2) == "string", "invalid username")
	assert(type(p3) == "string", "invalid birthday")

	local v7 = UrlBuilder.fromString("auth:v1/validators/username")
	local json = HttpService:JSONEncode({
		username = p2,
		birthday = p3
	})

	return p1(v7(), "POST", {
		maxRetryCount = 0,
		postBody = json
	})
end
