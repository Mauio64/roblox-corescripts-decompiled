local HttpService = game:GetService("HttpService")
local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)
local default = require(AppChatNetworking.url.HttpRequest).default

return function(p1, s1: string) -- line: 8
	-- upvalues: default (copy), HttpService (copy), CHAT_PLATFORM_BASE_URL (copy)
	local v7 = p1 or default
	local json = HttpService:JSONEncode({
		conversation_ids = { s1 }
	})

	return v7(`{ CHAT_PLATFORM_BASE_URL }/v1/mark-conversations`, "POST", {
		postBody = json
	})
end
