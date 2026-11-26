local CHAT_PLATFORM_BASE_URL = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/CHAT_PLATFORM_BASE_URL")

local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/rodux/RoduxNetworking")

require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/responses/SharedTypes")

return RoduxNetworking.POST("DuplicateConversation", function(callback, p2, p3)
	return callback(CHAT_PLATFORM_BASE_URL):path("v1"):path("create-conversations"):body({
		conversations = {
			{
				conversation_to_duplicate = p2,
				moderation_type = p3,
				type = "group",
				participant_user_ids = {}
			}
		}
	}):setStatusIds({ p2 })
end)
