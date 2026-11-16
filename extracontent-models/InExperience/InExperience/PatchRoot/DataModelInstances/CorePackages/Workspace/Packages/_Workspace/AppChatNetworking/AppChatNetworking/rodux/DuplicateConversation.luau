local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)

local RoduxNetworking = require(script.Parent.RoduxNetworking)

require(AppChatNetworking.responses.SharedTypes)

return RoduxNetworking.POST(script.Name, function(callback, conversation_to_duplicate: string, moderation_type)
	return callback(CHAT_PLATFORM_BASE_URL):path("v1"):path("create-conversations"):body({
		conversations = {
			{
				conversation_to_duplicate = conversation_to_duplicate,
				moderation_type = moderation_type,
				type = "group",
				participant_user_ids = {}
			}
		}
	}):setStatusIds({ conversation_to_duplicate })
end)
