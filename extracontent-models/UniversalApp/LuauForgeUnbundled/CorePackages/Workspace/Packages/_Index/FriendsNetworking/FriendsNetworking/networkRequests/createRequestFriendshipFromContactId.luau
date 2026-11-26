local FRIENDS_URL = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/FRIENDS_URL")
require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkingFriendsTypes")

return function(p2)
	return p2.roduxNetworking.POST("RequestFriendshipFromContactId", function(callback, p3)
		return callback(FRIENDS_URL, { currentUserId = p3.currentUserId }):path("v1"):path("contacts"):id(p3.contactId):path("request-friendship"):body({})
	end)
end
