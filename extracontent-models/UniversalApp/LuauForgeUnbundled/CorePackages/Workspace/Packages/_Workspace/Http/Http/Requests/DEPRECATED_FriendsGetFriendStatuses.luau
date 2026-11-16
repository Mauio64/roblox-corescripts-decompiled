local Players = game:GetService("Players")

local Url = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Http/Url")

return function(callback, list)
	local joined = table.concat(list, ",")
	local userId = tostring(Players.LocalPlayer.UserId)

	return callback(
		string.format("%s/users/%s/friends/statuses?userIds=%s", Url.FRIEND_URL, userId, joined),
		"GET"
	)
end
