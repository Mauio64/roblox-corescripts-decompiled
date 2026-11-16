local parent = script:FindFirstAncestor("PromptsServerDrivenUi").Parent

local HttpService = game:GetService("HttpService")
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

return function(callback, milestoneId: string, count: number)
	return callback(urlBuilder.fromString("apis:modals-api/v1/prompts/milestones/set")(), "POST", {
		postBody = HttpService:JSONEncode({ milestoneId = milestoneId, count = count })
	})
end
