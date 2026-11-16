local HttpService = game:GetService("HttpService")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/PromptsServerDrivenUi/UrlBuilder").UrlBuilder

return function(callback, p2, p3)
	return callback(urlBuilder.fromString("apis:modals-api/v1/prompts/milestones/set")(), "POST", {
		postBody = HttpService:JSONEncode({ milestoneId = p2, count = p3 })
	})
end
