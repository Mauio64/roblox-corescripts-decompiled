local Players = game:GetService("Players")
local throttleUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/AppCommonLib").ThrottleUserId

return function()
	return throttleUserId(
		game:DefineFastInt("LuaChatUseNewFriendsEndpointsV2", 0),
		Players.LocalPlayer.UserId
	)
end
