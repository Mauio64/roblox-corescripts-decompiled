local HttpService = game:GetService("HttpService")

local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Http").Url
require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Http")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UrlBuilder").UrlBuilder.new({
	base = url.USERS_URL,
	path = "usernames/users"
})

return function(callback, p2, p3)
	return callback(urlBuilder(), "POST", {
		postBody = HttpService:JSONEncode({
			usernames = { p2 },
			excludeBannedUsers = p3 or false
		})
	})
end
