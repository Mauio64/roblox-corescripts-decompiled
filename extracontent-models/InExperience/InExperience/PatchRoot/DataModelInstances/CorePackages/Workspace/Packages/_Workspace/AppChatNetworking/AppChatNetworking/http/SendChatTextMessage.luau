local HttpService = game:GetService("HttpService")
local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)
local default = require(AppChatNetworking.url.HttpRequest).default

return function(p1, s1: string, s2: string, s3: string?) -- line: 10
	-- upvalues: default (copy), HttpService (copy), CHAT_PLATFORM_BASE_URL (copy)
	local v9 = p1 or default
	local json = HttpService:JSONEncode({
		conversation_id = s1,
		messages = {{
			content = s2,
			replies_to = s3
		}}
	})

	return v9(`{ CHAT_PLATFORM_BASE_URL }/v1/send-messages`, "POST", {
		postBody = json
	})
end
