local Players = game:GetService("Players")

local url = require("@game/CorePackages/Workspace/Packages/_Workspace/LegacyFriendsRodux/Http").Url

local isNewFriendsEndpointsEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/LegacyFriendsRodux/SharedFlags").isNewFriendsEndpointsEnabled

return function(callback)
	local v5 = string.format(
		"%s/user/get-friendship-count?%s",
		url.API_URL,
		(tostring(Players.LocalPlayer.UserId))
	)

	if isNewFriendsEndpointsEnabled() then
		v5 = string.format("%s/my/friends/count", url.FRIEND_URL)
	end

	return callback(v5, "GET")
end
