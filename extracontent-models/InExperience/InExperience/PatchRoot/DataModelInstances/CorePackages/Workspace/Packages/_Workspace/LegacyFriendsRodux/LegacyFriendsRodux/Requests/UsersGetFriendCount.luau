local parent = script:FindFirstAncestor("LegacyFriendsRodux").Parent
local Players = game:GetService("Players")

local Http = require(parent.Http)
local Url = Http.Url

local SharedFlags = require(parent.SharedFlags)
local isNewFriendsEndpointsEnabled = SharedFlags.isNewFriendsEndpointsEnabled

return function(callback)
	local v = string.format("%s/user/get-friendship-count?%s", Url.API_URL, (tostring(Players.LocalPlayer.UserId)))

	if isNewFriendsEndpointsEnabled() then
		v = string.format("%s/my/friends/count", Url.FRIEND_URL)
	end

	return callback(v, "GET")
end
