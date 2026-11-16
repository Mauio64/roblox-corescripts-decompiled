local HttpService = game:GetService("HttpService")

local CHAT_PLATFORM_BASE_URL = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/CHAT_PLATFORM_BASE_URL")
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/HttpRequest").default
local getFFlagEnableSocialCards = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/SharedFlags").GetFFlagEnableSocialCards

return function(p2, p3, p4)
	local formatted = `conversation_id={HttpService:UrlEncode(p3)}`

	if p4 ~= nil and p4 ~= "" then
		formatted = `{formatted}&cursor={HttpService:UrlEncode(p4)}`
	end

	return (p2 or default)(
		`{module}/v1/get-conversation-messages?{`{formatted}&include_cards={getFFlagEnableSocialCards() and "true" or "false"}`}`,
		"GET"
	)
end
