local Parent = script:FindFirstAncestor("FriendsMenu").Parent
local Url = require(Parent.Http).Url

return function(p1, s1: string, s2: string, n1: number?, s3: string?) -- line: 6
	-- upvalues: Url (copy)
	local v8 = Url:makeQueryString({
		query = s2,
		cursor = s3,
		limit = n1
	})

	return p1(string.format("%s/users/%s/friends/search?%s", Url.FRIEND_URL, s1, v8), "GET")
end
