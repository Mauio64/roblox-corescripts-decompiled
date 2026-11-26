local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/RoduxNetworking")
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/HttpRequest")

return RoduxNetworking.config({
	keyPath = "ChatAppReducer.networkStatus",
	networkImpl = HttpRequest.default,
	killRequestWithFilteredIds = true
})
