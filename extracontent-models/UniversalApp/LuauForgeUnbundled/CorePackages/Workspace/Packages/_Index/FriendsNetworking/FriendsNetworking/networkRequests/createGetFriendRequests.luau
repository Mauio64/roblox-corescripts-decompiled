local FRIENDS_URL = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/FRIENDS_URL")
require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkingFriendsTypes")

local fFlagAddFriendsSessionId = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsNetworking/SharedFlags").FFlagAddFriendsSessionId

return function(p2)
	return p2.roduxNetworking.GET("GetFriendRequests", function(callback, data)
		local path = callback(FRIENDS_URL, { currentUserId = data.currentUserId }):path("v1"):path("my"):path("friends"):path("requests")
		local v5 = {
			fetchMutualFriends = data.fetchMutualFriends,
			sortOrder = data.sortOrder,
			limit = data.limit,
			cursor = data.cursor,
			sessionId = 0,
			uprankUnseen = true
		}
		local v6 = if fFlagAddFriendsSessionId then data.sessionId else nil
		v5.sessionId = v6
		return path:queryArgs(v5)
	end)
end
