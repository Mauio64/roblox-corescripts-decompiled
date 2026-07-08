local Parent = script:FindFirstAncestor("AuthCommon").Parent
local Url = require(Parent.Http).Url

require(Parent.Http)

local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder

return function(p1, s1: string) -- line: 33
	-- upvalues: UrlBuilder (copy), Url (copy)
	return p1(UrlBuilder.new({
		base = Url.USERS_URL,
		path = `users/{ s1 }`
	})(), "GET")
end
