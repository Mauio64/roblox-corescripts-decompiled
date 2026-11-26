local HttpService = game:GetService("HttpService")

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/UrlBuilder").UrlBuilder

return function(callback)
	local v5 = urlBuilder.fromString("apis:virtual-events/v1/notifications/preferences")

	local jsonEncode = HttpService:JSONEncode({ isEnabled = true })

	return callback(v5(), "POST", { postBody = jsonEncode })
end
