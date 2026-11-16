local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)

local RoduxNetworking = require(script.Parent.RoduxNetworking)

return RoduxNetworking.POST(script.Name, function(callback, conversation_ids)
	return callback(CHAT_PLATFORM_BASE_URL):path("v1"):path("get-conversations-participants-metadata"):body({
		conversation_ids = conversation_ids
	}):setStatusIds(conversation_ids)
end)
