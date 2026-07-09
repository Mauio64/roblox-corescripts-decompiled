local Players = game:GetService("Players")
local Http = script:FindFirstAncestor("Http")
local Url = require(Http.Url)

return function(p1, p2) -- line: 39
	-- upvalues: Players (copy), Url (copy)
	local v6 = table.concat(p2, ",")
	local str = tostring(Players.LocalPlayer.UserId)

	return p1(string.format("%s/users/%s/friends/statuses?userIds=%s", Url.FRIEND_URL, str, v6), "GET")
end
