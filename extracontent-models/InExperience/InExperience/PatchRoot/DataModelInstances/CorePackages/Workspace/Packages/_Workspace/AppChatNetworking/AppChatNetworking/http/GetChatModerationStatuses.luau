local HttpService = game:GetService("HttpService")

local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")

local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)
local HttpRequest = require(AppChatNetworking.url.HttpRequest)
local default = HttpRequest.default

return function(p, options)
	local jsonEncode = HttpService:JSONEncode({
		ids = options or {}
	})

	return (p or default)(`{CHAT_PLATFORM_BASE_URL}/v1/get-chat-moderation-statuses`, "POST", {
		postBody = jsonEncode
	})
end
