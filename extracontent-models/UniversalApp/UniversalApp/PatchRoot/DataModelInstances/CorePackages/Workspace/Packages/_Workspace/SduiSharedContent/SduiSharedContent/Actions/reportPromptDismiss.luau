local SduiSharedContent = script:FindFirstAncestor("SduiSharedContent")
local HttpService = game:GetService("HttpService")
local SduiSharedContentParent = SduiSharedContent.Parent
local UrlBuilder = require(SduiSharedContentParent.UrlBuilder).UrlBuilder

return function(p1, s1: string, s2: string?) -- line: 8
	-- upvalues: UrlBuilder (copy), HttpService (copy)
	return p1(UrlBuilder.fromString("apis:modals-api/v1/prompts/dismiss")(), "POST", {
		postBody = HttpService:JSONEncode({
			promptType = s1,
			promptId = s2
		})
	})
end
