local url = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/Http").Url

return function(callback, p2, p3, p4, p5)
	local queryString = url:makeQueryString({ query = p3, cursor = p5, limit = p4 })

	return callback(string.format("%s/users/%s/friends/search?%s", url.FRIEND_URL, p2, queryString), "GET")
end
