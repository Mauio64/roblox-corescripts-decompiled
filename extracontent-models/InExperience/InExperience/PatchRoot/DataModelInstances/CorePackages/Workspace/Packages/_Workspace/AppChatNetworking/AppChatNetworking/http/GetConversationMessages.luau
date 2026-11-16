local HttpService = game:GetService("HttpService")
local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local parent = AppChatNetworking.Parent

local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)
local HttpRequest = require(AppChatNetworking.url.HttpRequest)
local default = HttpRequest.default
local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnableSocialCards = SharedFlags.GetFFlagEnableSocialCards

return function(p, p2: string, p3: string?)
	local formatted = `conversation_id={HttpService:UrlEncode(p2)}`

	if p3 ~= nil and p3 ~= "" then
		formatted = `{formatted}&cursor={HttpService:UrlEncode(p3)}`
	end

	return (p or default)(
		`{CHAT_PLATFORM_BASE_URL}/v1/get-conversation-messages?{`{formatted}&include_cards={GetFFlagEnableSocialCards() and "true" or "false"}`}`,
		"GET"
	)
end
