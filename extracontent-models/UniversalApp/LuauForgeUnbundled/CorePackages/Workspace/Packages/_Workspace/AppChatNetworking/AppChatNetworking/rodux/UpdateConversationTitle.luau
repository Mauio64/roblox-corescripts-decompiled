local CHAT_PLATFORM_BASE_URL = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/CHAT_PLATFORM_BASE_URL")

return require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/rodux/RoduxNetworking").POST("UpdateConversationTitle", function(callback, p2, p3)
	return callback(CHAT_PLATFORM_BASE_URL):path("v1"):path("update-conversations"):body({
		conversations = {
			{ id = p2, name = p3 }
		}
	}):setStatusIds(p2)
end)
