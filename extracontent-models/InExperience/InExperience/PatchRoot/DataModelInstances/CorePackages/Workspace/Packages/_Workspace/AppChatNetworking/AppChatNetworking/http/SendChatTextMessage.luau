local HttpService = game:GetService("HttpService")
local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")

local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)
local HttpRequest = require(AppChatNetworking.url.HttpRequest)
local default = HttpRequest.default

return function(p, conversation_id: string, content: string, replies_to: string?)
	local jsonEncode = HttpService:JSONEncode({
		conversation_id = conversation_id,
		messages = {
			{ content = content, replies_to = replies_to }
		}
	})

	return (p or default)(`{CHAT_PLATFORM_BASE_URL}/v1/send-messages`, "POST", {
		postBody = jsonEncode
	})
end
