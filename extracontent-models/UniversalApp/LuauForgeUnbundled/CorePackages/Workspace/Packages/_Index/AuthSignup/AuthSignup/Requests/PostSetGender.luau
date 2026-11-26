local HttpService = game:GetService("HttpService")

local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Http").Url
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/UrlBuilder").UrlBuilder.new({
	base = url.USERS_URL,
	path = "gender"
})

return function(callback, p2)
	return callback(urlBuilder(), "POST", {
		postBody = HttpService:JSONEncode({ gender = p2 })
	})
end
