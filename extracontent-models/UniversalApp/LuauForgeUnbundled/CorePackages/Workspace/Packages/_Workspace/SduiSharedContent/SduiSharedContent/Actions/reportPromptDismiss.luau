local HttpService = game:GetService("HttpService")

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/UrlBuilder").UrlBuilder

return function(callback, p2, p3)
	return callback(urlBuilder.fromString("apis:modals-api/v1/prompts/dismiss")(), "POST", {
		postBody = HttpService:JSONEncode({ promptType = p2, promptId = p3 })
	})
end
