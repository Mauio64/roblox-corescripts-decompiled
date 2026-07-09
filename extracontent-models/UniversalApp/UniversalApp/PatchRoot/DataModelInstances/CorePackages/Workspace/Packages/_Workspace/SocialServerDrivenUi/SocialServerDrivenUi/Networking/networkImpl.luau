local Parent = script:FindFirstAncestor("SocialServerDrivenUi").Parent
local HttpRequest = require(Parent.HttpRequest)
local v3 = game:DefineFastInt("SocialServerDrivenUiHttpRetryCount", 3)

return HttpRequest.config({
	requestFunction = HttpRequest.requestFunctions.RequestInternal,
	maxRetryCount = v3
})
