local Url = require(script.Parent.Parent.Url)

return function(callback, p, userSort)
	local queryString = Url:makeQueryString({ userSort = userSort })

	return callback(string.format("%s/users/%s/friends?%s", Url.FRIEND_URL, p, queryString), "GET")
end
