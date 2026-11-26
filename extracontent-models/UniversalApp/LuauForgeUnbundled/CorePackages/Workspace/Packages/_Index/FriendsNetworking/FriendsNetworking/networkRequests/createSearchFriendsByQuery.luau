local FRIENDS_URL = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/FRIENDS_URL")
require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkingFriendsTypes")

return function(p2)
	return p2.roduxNetworking.GET("SearchFriendsByQuery", function(callback, p3, data)
		local path = callback(FRIENDS_URL):path("v1"):path("users"):id(p3):path("friends"):path("search")

		local v6 = if data then data.query else nil
		local v7 = if data then data.userSort else nil
		local v8 = if data then data.cursor else nil
		local v9 = if data then data.limit else nil
		return path:queryArgs({ query = v6, userSort = v7, cursor = v8, limit = v9 })
	end)
end
