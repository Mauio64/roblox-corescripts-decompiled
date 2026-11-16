local parent = script:FindFirstAncestor("SharedFlags").Parent

local Players = game:GetService("Players")
local AppCommonLib = require(parent.AppCommonLib)
local ThrottleUserId = AppCommonLib.ThrottleUserId

return function()
	return ThrottleUserId(game:DefineFastInt("LuaChatUseNewFriendsEndpointsV2", 0), Players.LocalPlayer.UserId)
end
