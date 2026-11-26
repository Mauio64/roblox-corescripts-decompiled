local Url = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Http/Url")

return function(callback, p2, p3)
	local queryString = Url:makeQueryString({ userSort = p3 })

	return callback(string.format("%s/users/%s/friends?%s", Url.FRIEND_URL, p2, queryString), "GET")
end
