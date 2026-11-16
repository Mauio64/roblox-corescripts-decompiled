local HttpService = game:GetService("HttpService")

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UrlBuilder").UrlBuilder

return function(callback, p2)
	local v5 = urlBuilder.fromString("apis:account-switcher/v1/logoutAllLoggedInUsers")
	local jsonEncode = HttpService:JSONEncode({ encrypted_users_data_blob = p2 })

	return callback(v5(), "POST", { postBody = jsonEncode })
end
