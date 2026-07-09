local Parent = script:FindFirstAncestor("SocialTabsPage").Parent
local HttpRequest = require(Parent.HttpRequest)
local v3 = game:DefineFastInt("SocialTabsPageHttpRetryCount", 3)

return HttpRequest.config({
	requestFunction = HttpRequest.requestFunctions.RequestInternal,
	maxRetryCount = v3
})
