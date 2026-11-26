local CHAT_PLATFORM_BASE_URL = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/CHAT_PLATFORM_BASE_URL")

return require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/rodux/RoduxNetworking").POST("ClearGlobalUnreadCount", function(callback)
	return callback(CHAT_PLATFORM_BASE_URL):path("v1"):path("clear-global-unread-count"):body({})
end)
