local HttpService = game:GetService("HttpService")

local CHAT_PLATFORM_BASE_URL = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/CHAT_PLATFORM_BASE_URL")
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/HttpRequest").default

return function(p2, p3, p4, p5, p6)
	local jsonEncode = HttpService:JSONEncode({
		conversation_id = p3,
		message_id = p4,
		emote_id = p5,
		current_emote_id = p6
	})

	return (p2 or default)(`{module}/v1/set-messages-reactions`, "POST", {
		postBody = jsonEncode
	})
end
