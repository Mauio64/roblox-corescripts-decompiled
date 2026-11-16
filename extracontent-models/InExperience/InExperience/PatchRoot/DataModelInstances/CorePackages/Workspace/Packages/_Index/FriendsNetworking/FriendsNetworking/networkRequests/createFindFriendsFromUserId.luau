local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)
require(script.Parent.Parent.networkingFriendsTypes)

return function(p)
	return p.roduxNetworking.GET("FindFriendsFromUserId", function(callback, p2, data)
		local path = callback(FRIENDS_URL):path("v1"):path("users"):id(p2):path("friends"):path("find")
		local userSort

		if data then
			userSort = data.userSort
		end

		local cursor

		if data then
			cursor = data.cursor
		end

		local limit

		if data then
			limit = data.limit
		end

		return path:queryArgs({ userSort = userSort, cursor = cursor, limit = limit })
	end)
end
