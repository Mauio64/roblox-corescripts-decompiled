local parent = script:FindFirstAncestor("SocialTabsPage").Parent

local HttpRequest = require(parent.HttpRequest)

local defineFastInt = game:DefineFastInt("SocialTabsPageHttpRetryCount", 3)

return HttpRequest.config({
	requestFunction = HttpRequest.requestFunctions.RequestInternal,
	maxRetryCount = defineFastInt
})
