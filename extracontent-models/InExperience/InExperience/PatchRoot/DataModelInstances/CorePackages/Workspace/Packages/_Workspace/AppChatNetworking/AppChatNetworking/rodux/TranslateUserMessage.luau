local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)

local RoduxNetworking = require(script.Parent.RoduxNetworking)

return RoduxNetworking.POST(script.Name, function(callback, conversation_id: string, message_id: string)
	return callback(CHAT_PLATFORM_BASE_URL):path("v1"):path("translate-user-message"):body({
		conversation_id = conversation_id,
		message_id = message_id
	})
end)
