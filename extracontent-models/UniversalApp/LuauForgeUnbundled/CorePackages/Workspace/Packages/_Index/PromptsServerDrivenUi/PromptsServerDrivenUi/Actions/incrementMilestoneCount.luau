local HttpService = game:GetService("HttpService")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/PromptsServerDrivenUi/UrlBuilder").UrlBuilder

return function(callback, p2)
	return callback(urlBuilder.fromString("apis:modals-api/v1/prompts/milestones/increment")(), "POST", {
		postBody = HttpService:JSONEncode({ milestoneId = p2 })
	})
end
