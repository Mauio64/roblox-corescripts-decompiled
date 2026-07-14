local HttpService = game:GetService("HttpService")
local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local AppChatNetworkingParent = AppChatNetworking.Parent
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)
local default = require(AppChatNetworking.url.HttpRequest).default
local GetFFlagEnableSocialCards = require(AppChatNetworkingParent.SharedFlags).GetFFlagEnableSocialCards

return function(p1, s1: string, s2: string?) -- line: 12
	-- upvalues: default (copy), HttpService (copy), GetFFlagEnableSocialCards (copy), CHAT_PLATFORM_BASE_URL (copy)
	local v10 = p1 or default
	local v11 = `conversation_id={ HttpService:UrlEncode(s1) }`

	if s2 ~= nil and s2 ~= "" then
		v11 = `{ v11 }&cursor={ HttpService:UrlEncode(s2) }`
	end

	local v12 = `{ v11 }&include_cards={ not GetFFlagEnableSocialCards() and "false" or "true" }`

	return v10(`{ CHAT_PLATFORM_BASE_URL }/v1/get-conversation-messages?{ v12 }`, "GET")
end
