local Players = game:GetService("Players")

local NetworkingBlocking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/NetworkingBlocking")

return function()
	return function(object)
		if Players.LocalPlayer then
			return object:dispatch(NetworkingBlocking.GetFriendsCountFromUserId.API(Players.LocalPlayer.UserId))
		end
	end
end
