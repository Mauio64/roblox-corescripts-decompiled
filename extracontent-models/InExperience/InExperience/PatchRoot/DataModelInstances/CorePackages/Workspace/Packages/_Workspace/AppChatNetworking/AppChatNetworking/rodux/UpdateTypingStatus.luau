local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)

local RoduxNetworking = require(script.Parent.RoduxNetworking)

return RoduxNetworking.POST(script.Name, function(callback, conversation_id: string)
	return callback(CHAT_PLATFORM_BASE_URL):path("v1"):path("update-typing-status"):body({
		conversation_id = conversation_id
	}):setStatusIds(conversation_id)
end)
