local Parent = script:FindFirstAncestor("PlayerContextualMenu").Parent
local HttpRequest = require(Parent.HttpRequest)

return HttpRequest.config({
	maxRetryCount = 0,
	requestFunction = HttpRequest.requestFunctions.HttpRbxApi
})
