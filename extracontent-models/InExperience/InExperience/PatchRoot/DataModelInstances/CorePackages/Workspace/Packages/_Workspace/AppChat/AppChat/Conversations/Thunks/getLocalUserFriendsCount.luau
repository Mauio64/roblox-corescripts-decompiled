local Players = game:GetService("Players")

local AppChat = script:FindFirstAncestor("AppChat")

local NetworkingFriends = require(AppChat.Http.NetworkingFriends)

return function()
	return function(object)
		if Players.LocalPlayer then
			return object:dispatch(NetworkingFriends.GetFriendsCountFromUserId.API(Players.LocalPlayer.UserId))
		end
	end
end
