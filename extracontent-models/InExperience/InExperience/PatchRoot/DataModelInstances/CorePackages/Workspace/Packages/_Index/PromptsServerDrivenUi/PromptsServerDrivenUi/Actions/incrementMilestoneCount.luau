local parent = script:FindFirstAncestor("PromptsServerDrivenUi").Parent

local HttpService = game:GetService("HttpService")
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

return function(callback, milestoneId: string)
	return callback(urlBuilder.fromString("apis:modals-api/v1/prompts/milestones/increment")(), "POST", {
		postBody = HttpService:JSONEncode({ milestoneId = milestoneId })
	})
end
