local Parent = script:FindFirstAncestor("LegacyFriendsRodux").Parent
local Players = game:GetService("Players")
local Url = require(Parent.Http).Url
local isNewFriendsEndpointsEnabled = require(Parent.SharedFlags).isNewFriendsEndpointsEnabled

return function(p1) -- line: 22
	-- upvalues: Url (copy), Players (copy), isNewFriendsEndpointsEnabled (copy)
	local v6 = string.format("%s/user/get-friendship-count?%s", Url.API_URL, (tostring(Players.LocalPlayer.UserId)))

	if isNewFriendsEndpointsEnabled() then
		v6 = string.format("%s/my/friends/count", Url.FRIEND_URL)
	end

	return p1(v6, "GET")
end
