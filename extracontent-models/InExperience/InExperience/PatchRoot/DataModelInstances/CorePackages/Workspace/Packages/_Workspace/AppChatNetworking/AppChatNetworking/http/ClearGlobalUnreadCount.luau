local HttpService = game:GetService("HttpService")
local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)
local default = require(AppChatNetworking.url.HttpRequest).default

return function(p1) -- line: 8
	-- upvalues: default (copy), HttpService (copy), CHAT_PLATFORM_BASE_URL (copy)
	local v6 = p1 or default
	local json = HttpService:JSONEncode({})

	return v6(`{ CHAT_PLATFORM_BASE_URL }/v1/clear-global-unread-count`, "POST", {
		postBody = json
	})
end
