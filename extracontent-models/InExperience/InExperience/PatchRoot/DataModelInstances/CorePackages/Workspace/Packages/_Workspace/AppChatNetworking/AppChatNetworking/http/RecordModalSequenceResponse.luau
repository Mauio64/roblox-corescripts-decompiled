local HttpService = game:GetService("HttpService")
local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")

local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)
local HttpRequest = require(AppChatNetworking.url.HttpRequest)
local default = HttpRequest.default
require(AppChatNetworking.responses.SharedTypes)

return function(p, data)
	local jsonEncode = HttpService:JSONEncode({
		action_type = data.actionType,
		modal_sequence = data.modalSequence,
		modal_id = data.modalId,
		modal_variant = data.modalVariant,
		conversation_id = data.conversationId,
		friend_id = data.friendId
	})

	return (p or default)(`{CHAT_PLATFORM_BASE_URL}/v1/record-modal-sequence-response`, "POST", {
		postBody = jsonEncode,
		maxRetryCount = 0
	})
end
