local HttpService = game:GetService("HttpService")
local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local parent = AppChatNetworking.Parent

local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)
local HttpRequest = require(AppChatNetworking.url.HttpRequest)
local default = HttpRequest.default
local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnableSocialCards = SharedFlags.GetFFlagEnableSocialCards

return function(p, conversation_id: string, items, p2)
	local messages = {}

	for _, item in items do
		table.insert(messages, { conversation_id = conversation_id, message_id = item })
	end

	local jsonEncode = HttpService:JSONEncode({
		messages = messages,
		include_reactions = p2 and p2.include_reactions and true or false,
		include_cards = GetFFlagEnableSocialCards() and true or false
	})

	return (p or default)(`{CHAT_PLATFORM_BASE_URL}/v1/get-messages`, "POST", {
		postBody = jsonEncode
	})
end
