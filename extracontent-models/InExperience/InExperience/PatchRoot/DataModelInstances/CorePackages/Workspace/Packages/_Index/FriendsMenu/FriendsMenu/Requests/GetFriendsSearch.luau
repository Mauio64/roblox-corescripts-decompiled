local parent = script:FindFirstAncestor("FriendsMenu").Parent

local Http = require(parent.Http)
local Url = Http.Url

return function(callback, p: string, query: string, limit: number?, cursor: string?)
	local queryString = Url:makeQueryString({ query = query, cursor = cursor, limit = limit })

	return callback(string.format("%s/users/%s/friends/search?%s", Url.FRIEND_URL, p, queryString), "GET")
end
