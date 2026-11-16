local HttpService = game:GetService("HttpService")
local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")

local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)
local HttpRequest = require(AppChatNetworking.url.HttpRequest)
local default = HttpRequest.default

return function(p, conversation_id: string, suggestion_types, max_suggestions: number)
	local jsonEncode = HttpService:JSONEncode({
		conversation_id = conversation_id,
		suggestion_types = suggestion_types,
		max_suggestions = max_suggestions
	})

	return (p or default)(`{CHAT_PLATFORM_BASE_URL}/v1/get-suggestions`, "POST", {
		postBody = jsonEncode
	})
end
