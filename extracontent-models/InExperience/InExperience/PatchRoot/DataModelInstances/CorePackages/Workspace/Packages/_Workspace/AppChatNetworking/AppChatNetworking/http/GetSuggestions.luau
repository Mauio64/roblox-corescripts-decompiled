local HttpService = game:GetService("HttpService")
local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)
local default = require(AppChatNetworking.url.HttpRequest).default

return function(p1, s1: string, t1: {[any]: any}, n1: number) -- line: 8
	-- upvalues: default (copy), HttpService (copy), CHAT_PLATFORM_BASE_URL (copy)
	local v9 = p1 or default
	local json = HttpService:JSONEncode({
		conversation_id = s1,
		suggestion_types = t1,
		max_suggestions = n1
	})

	return v9(`{ CHAT_PLATFORM_BASE_URL }/v1/get-suggestions`, "POST", {
		postBody = json
	})
end
