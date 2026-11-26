local HttpService = game:GetService("HttpService")

local CHAT_PLATFORM_BASE_URL = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/CHAT_PLATFORM_BASE_URL")
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/HttpRequest").default
local getFFlagEnableSocialCards = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/SharedFlags").GetFFlagEnableSocialCards

return function(p2, p3, items, p4)
	local v6 = {}

	for k, item in items do
		table.insert(v6, { conversation_id = p3, message_id = item })
	end

	local jsonEncode = HttpService:JSONEncode({
		messages = v6,
		include_reactions = p4 and p4.include_reactions and true or false,
		include_cards = getFFlagEnableSocialCards() and true or false
	})

	return (p2 or default)(`{module}/v1/get-messages`, "POST", { postBody = jsonEncode })
end
