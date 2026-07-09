local Parent = script:FindFirstAncestor("AuthSignup").Parent
local HttpService = game:GetService("HttpService")
local Url = require(Parent.Http).Url
local v4 = require(Parent.UrlBuilder).UrlBuilder.new({
	path = "gender",
	base = Url.USERS_URL
})

return function(p1, s1: string) -- line: 55
	-- upvalues: v4 (copy), HttpService (copy)
	return p1(v4(), "POST", {
		postBody = HttpService:JSONEncode({
			gender = s1
		})
	})
end
