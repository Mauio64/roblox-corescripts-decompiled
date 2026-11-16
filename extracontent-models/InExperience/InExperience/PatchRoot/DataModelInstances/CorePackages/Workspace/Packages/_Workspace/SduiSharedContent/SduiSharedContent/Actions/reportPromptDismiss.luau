local SduiSharedContent = script:FindFirstAncestor("SduiSharedContent")

local HttpService = game:GetService("HttpService")

local parent = SduiSharedContent.Parent
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

return function(callback, promptType: string, promptId: string?)
	return callback(urlBuilder.fromString("apis:modals-api/v1/prompts/dismiss")(), "POST", {
		postBody = HttpService:JSONEncode({ promptType = promptType, promptId = promptId })
	})
end
