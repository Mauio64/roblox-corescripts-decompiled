local HttpService = game:GetService("HttpService")
local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)
local default = require(AppChatNetworking.url.HttpRequest).default

return function(p1, s1: string, s2: string?) -- line: 10
	-- upvalues: default (copy), HttpService (copy), CHAT_PLATFORM_BASE_URL (copy)
	local v8 = p1 or default
	local v9 = `conversation_id={ HttpService:UrlEncode(s1) }`

	if s2 ~= nil and s2 ~= "" then
		v9 = `{ v9 }&cursor={ HttpService:UrlEncode(s2) }`
	end

	return v8(`{ CHAT_PLATFORM_BASE_URL }/v1/get-conversation-messages?{ v9 }`, "GET")
end
