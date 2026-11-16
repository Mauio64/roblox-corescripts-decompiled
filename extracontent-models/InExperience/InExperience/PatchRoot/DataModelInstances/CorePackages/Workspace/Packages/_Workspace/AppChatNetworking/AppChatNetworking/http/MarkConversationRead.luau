local HttpService = game:GetService("HttpService")
local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")

local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)
local HttpRequest = require(AppChatNetworking.url.HttpRequest)
local default = HttpRequest.default

return function(p, p2: string)
	local jsonEncode = HttpService:JSONEncode({
		conversation_ids = { p2 }
	})

	return (p or default)(`{CHAT_PLATFORM_BASE_URL}/v1/mark-conversations`, "POST", {
		postBody = jsonEncode
	})
end
