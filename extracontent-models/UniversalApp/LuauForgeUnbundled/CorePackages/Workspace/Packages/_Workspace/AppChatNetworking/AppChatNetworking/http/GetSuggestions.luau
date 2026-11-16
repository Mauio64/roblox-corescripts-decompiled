local HttpService = game:GetService("HttpService")

local CHAT_PLATFORM_BASE_URL = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/CHAT_PLATFORM_BASE_URL")
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/HttpRequest").default

return function(p2, p3, p4, p5)
	local jsonEncode = HttpService:JSONEncode({
		conversation_id = p3,
		suggestion_types = p4,
		max_suggestions = p5
	})

	return (p2 or default)(`{module}/v1/get-suggestions`, "POST", {
		postBody = jsonEncode
	})
end
