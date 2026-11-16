local HttpService = game:GetService("HttpService")

local CHAT_PLATFORM_BASE_URL = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/CHAT_PLATFORM_BASE_URL")
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/HttpRequest").default
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/responses/SharedTypes")

return function(p2, data)
	local jsonEncode = HttpService:JSONEncode({
		action_type = data.actionType,
		modal_sequence = data.modalSequence,
		modal_id = data.modalId,
		modal_variant = data.modalVariant,
		conversation_id = data.conversationId,
		friend_id = data.friendId
	})

	return (p2 or default)(`{module}/v1/record-modal-sequence-response`, "POST", {
		postBody = jsonEncode,
		maxRetryCount = 0
	})
end
