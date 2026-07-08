local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local AppChatNetworkingParent = AppChatNetworking.Parent
local RoduxNetworking = require(AppChatNetworkingParent.RoduxNetworking)
local HttpRequest = require(AppChatNetworking.url.HttpRequest)

return RoduxNetworking.config({
	keyPath = "ChatAppReducer.networkStatus",
	killRequestWithFilteredIds = true,
	networkImpl = HttpRequest.default
})
