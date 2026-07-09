local Url = require(script.Parent.Parent.Url)

return function(p1, p2, p3) -- line: 5
	-- upvalues: Url (copy)
	local v5 = Url:makeQueryString({
		userSort = p3
	})

	return p1(string.format("%s/users/%s/friends?%s", Url.FRIEND_URL, p2, v5), "GET")
end
