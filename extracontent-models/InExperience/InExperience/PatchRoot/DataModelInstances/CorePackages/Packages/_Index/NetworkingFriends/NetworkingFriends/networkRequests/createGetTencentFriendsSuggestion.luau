local FRIENDS_URL = require(script.Parent.Parent.FRIENDS_URL)
require(script.Parent.Parent.networkingFriendsTypes)

return function(p)
	return p.roduxNetworking.GET({ Name = "GetTencentFriendsSuggestion" }, function(callback, data)
		return callback(FRIENDS_URL):path("v1"):path("tecent-friends-suggestion"):queryArgs({
			userOpenId = data.userOpenId,
			userAccessToken = data.userAccessToken,
			type = data.type,
			appType = data.appType
		})
	end)
end
