local parent = script:FindFirstAncestor("FriendsNetworking").Parent

local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)
require(script.Parent.Parent.networkingFriendsTypes)

local SharedFlags = require(parent.SharedFlags)
local FFlagAddFriendsSessionId = SharedFlags.FFlagAddFriendsSessionId

return function(p)
	return p.roduxNetworking.GET("GetFriendRequests", function(callback, data)
		local path = callback(FRIENDS_URL, { currentUserId = data.currentUserId }):path("v1"):path("my"):path("friends"):path("requests")
		local v = {
			fetchMutualFriends = data.fetchMutualFriends,
			sortOrder = data.sortOrder,
			limit = data.limit,
			cursor = data.cursor,
			sessionId = 0,
			uprankUnseen = true
		}
		local sessionId

		if FFlagAddFriendsSessionId then
			sessionId = data.sessionId
		end

		v.sessionId = sessionId
		return path:queryArgs(v)
	end)
end
