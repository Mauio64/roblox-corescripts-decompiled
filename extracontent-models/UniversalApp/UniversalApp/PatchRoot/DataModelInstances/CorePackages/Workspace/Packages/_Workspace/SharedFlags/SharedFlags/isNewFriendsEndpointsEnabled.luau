local Parent = script:FindFirstAncestor("SharedFlags").Parent
local Players = game:GetService("Players")
local ThrottleUserId = require(Parent.AppCommonLib).ThrottleUserId

return function() -- line: 7
	-- upvalues: ThrottleUserId (copy), Players (copy)
	return ThrottleUserId(game:DefineFastInt("LuaChatUseNewFriendsEndpointsV2", 0), Players.LocalPlayer.UserId)
end
