local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local parent = AppChatNetworking.Parent
local RoduxNetworking = require(parent.RoduxNetworking)
local HttpRequest = require(AppChatNetworking.url.HttpRequest)

return RoduxNetworking.config({
	keyPath = "ChatAppReducer.networkStatus",
	networkImpl = HttpRequest.default,
	killRequestWithFilteredIds = true
})
