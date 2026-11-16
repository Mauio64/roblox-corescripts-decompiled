local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)

local RoduxNetworking = require(script.Parent.RoduxNetworking)

return RoduxNetworking.POST(script.Name, function(callback, data)
	return callback(CHAT_PLATFORM_BASE_URL):path("v2"):path("get-modal-sequence"):body({
		is_in_experience = data.isInExperience,
		modal_sequence = data.modalSequence,
		conversation_id = data.conversationId,
		friend_id = data.friendId
	})
end)
