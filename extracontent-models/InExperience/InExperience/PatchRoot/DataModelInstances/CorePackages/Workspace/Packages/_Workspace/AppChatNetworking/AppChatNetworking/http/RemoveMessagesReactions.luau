local HttpService = game:GetService("HttpService")
local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")

local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)
local HttpRequest = require(AppChatNetworking.url.HttpRequest)
local default = HttpRequest.default

return function(p, conversation_id: string, message_id: string, emote_id: string)
	local jsonEncode = HttpService:JSONEncode({
		conversation_id = conversation_id,
		message_id = message_id,
		emote_id = emote_id
	})

	return (p or default)(`{CHAT_PLATFORM_BASE_URL}/v1/remove-messages-reactions`, "POST", {
		postBody = jsonEncode
	})
end
