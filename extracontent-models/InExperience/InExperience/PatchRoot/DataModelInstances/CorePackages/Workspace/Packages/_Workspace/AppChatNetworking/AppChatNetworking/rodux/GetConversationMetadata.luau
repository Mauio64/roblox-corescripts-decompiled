local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)

local RoduxNetworking = require(script.Parent.RoduxNetworking)

return RoduxNetworking.GET(script.Name, function(callback)
	return callback(CHAT_PLATFORM_BASE_URL):path("v1"):path("get-conversation-metadata")
end)
