local Parent = script:FindFirstAncestor("AuthCommon").Parent
local HttpService = game:GetService("HttpService")
local Url = require(Parent.Http).Url

require(Parent.Http)

local v4 = require(Parent.UrlBuilder).UrlBuilder.new({
	path = "usernames/users",
	base = Url.USERS_URL
})

return function(p1, s1: string, b1: boolean?) -- line: 40
	-- upvalues: v4 (copy), HttpService (copy)
	return p1(v4(), "POST", {
		postBody = HttpService:JSONEncode({
			usernames = { s1 },
			excludeBannedUsers = b1 or false
		})
	})
end
