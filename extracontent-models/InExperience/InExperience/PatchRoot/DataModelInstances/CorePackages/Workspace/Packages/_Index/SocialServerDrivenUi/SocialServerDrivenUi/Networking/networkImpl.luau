local parent = script:FindFirstAncestor("SocialServerDrivenUi").Parent

local HttpRequest = require(parent.HttpRequest)

local defineFastInt = game:DefineFastInt("SocialServerDrivenUiHttpRetryCount", 3)

return HttpRequest.config({
	requestFunction = HttpRequest.requestFunctions.RequestInternal,
	maxRetryCount = defineFastInt
})
