local CHAT_PLATFORM_BASE_URL = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/CHAT_PLATFORM_BASE_URL")

return require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/rodux/RoduxNetworking").POST("TranslateUserMessage", function(callback, p2, p3)
	return callback(CHAT_PLATFORM_BASE_URL):path("v1"):path("translate-user-message"):body({
		conversation_id = p2,
		message_id = p3
	})
end)
