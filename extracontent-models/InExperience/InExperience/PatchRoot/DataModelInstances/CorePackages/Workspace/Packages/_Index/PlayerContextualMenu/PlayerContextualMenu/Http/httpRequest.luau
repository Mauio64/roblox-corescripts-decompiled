local parent = script:FindFirstAncestor("PlayerContextualMenu").Parent
local HttpRequest = require(parent.HttpRequest)

return HttpRequest.config({
	requestFunction = HttpRequest.requestFunctions.HttpRbxApi,
	maxRetryCount = 0
})
