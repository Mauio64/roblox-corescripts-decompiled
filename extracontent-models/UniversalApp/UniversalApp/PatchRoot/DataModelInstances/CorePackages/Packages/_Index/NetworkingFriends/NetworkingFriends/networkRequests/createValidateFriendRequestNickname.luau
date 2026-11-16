local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)
require(script.Parent.Parent.networkingFriendsTypes)

return function(p)
	return p.roduxNetworking.POST({ Name = "ValidateFriendRequestNickname" }, function(callback, p2)
		return callback(FRIENDS_URL, { currentUserId = p2.currentUserId }):path("v1"):path("my"):path("friends"):path("validate-nickname"):body({
			senderNickname = p2.senderNickname
		})
	end)
end
