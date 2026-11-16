local CHAT_PLATFORM_BASE_URL = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/CHAT_PLATFORM_BASE_URL")

return require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/rodux/RoduxNetworking").POST("GetConversationsParticipantsMetadata", function(callback, p2)
	return callback(CHAT_PLATFORM_BASE_URL):path("v1"):path("get-conversations-participants-metadata"):body({
		conversation_ids = p2
	}):setStatusIds(p2)
end)
