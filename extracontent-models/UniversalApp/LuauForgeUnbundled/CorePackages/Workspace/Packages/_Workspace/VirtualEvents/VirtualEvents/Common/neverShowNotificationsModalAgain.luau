local HttpService = game:GetService("HttpService")

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/UrlBuilder").UrlBuilder

return function(callback)
	return callback(urlBuilder.fromString("apis:virtual-events/v1/notifications/modal-history")(), "POST", {
		postBody = HttpService:JSONEncode({})
	})
end
