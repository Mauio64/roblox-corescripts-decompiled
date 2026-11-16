local HttpService = game:GetService("HttpService")

local CHAT_PLATFORM_BASE_URL = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/CHAT_PLATFORM_BASE_URL")
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/HttpRequest").default

return function(p2, options)
	local jsonEncode = HttpService:JSONEncode({
		ids = options or {}
	})

	return (p2 or default)(`{module}/v1/get-chat-moderation-statuses`, "POST", {
		postBody = jsonEncode
	})
end
