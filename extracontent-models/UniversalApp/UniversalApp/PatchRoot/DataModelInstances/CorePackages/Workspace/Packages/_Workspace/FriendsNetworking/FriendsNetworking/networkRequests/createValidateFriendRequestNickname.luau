local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)

require(script.Parent.Parent.networkingFriendsTypes)

return function(p1) -- line: 8
	-- upvalues: FRIENDS_URL (copy)
	return p1.roduxNetworking.POST({
		Name = "ValidateFriendRequestNickname"
	}, function(p2, t1: {[any]: any}) -- line: 13
		-- upvalues: FRIENDS_URL (copy)
		return p2(FRIENDS_URL, {
			currentUserId = t1.currentUserId
		}):path("v1"):path("my"):path("friends"):path("validate-nickname"):body({
			senderNickname = t1.senderNickname
		})
	end)
end
