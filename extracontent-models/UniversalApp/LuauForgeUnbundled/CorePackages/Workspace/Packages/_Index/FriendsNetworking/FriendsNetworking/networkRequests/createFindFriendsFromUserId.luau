local FRIENDS_URL = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/FRIENDS_URL")
require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkingFriendsTypes")

return function(p2)
	return p2.roduxNetworking.GET("FindFriendsFromUserId", function(callback, p3, data)
		local path = callback(FRIENDS_URL):path("v1"):path("users"):id(p3):path("friends"):path("find")

		local v6 = if data then data.userSort else nil
		local v7 = if data then data.cursor else nil
		local v8 = if data then data.limit else nil
		return path:queryArgs({ userSort = v6, cursor = v7, limit = v8 })
	end)
end
