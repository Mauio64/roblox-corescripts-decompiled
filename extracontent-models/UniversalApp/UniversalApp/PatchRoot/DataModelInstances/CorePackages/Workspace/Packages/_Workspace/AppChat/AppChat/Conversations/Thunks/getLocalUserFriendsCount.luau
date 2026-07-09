local Players = game:GetService("Players")
local AppChat = script:FindFirstAncestor("AppChat")
local NetworkingFriends = require(AppChat.Http.NetworkingFriends)

return function() -- line: 7
	-- upvalues: Players (copy), NetworkingFriends (copy)
	return function(p1) -- line: 8
		-- upvalues: Players (copy), NetworkingFriends (copy)
		if Players.LocalPlayer then
			return p1:dispatch(NetworkingFriends.GetFriendsCountFromUserId.API(Players.LocalPlayer.UserId))
		end
	end
end
