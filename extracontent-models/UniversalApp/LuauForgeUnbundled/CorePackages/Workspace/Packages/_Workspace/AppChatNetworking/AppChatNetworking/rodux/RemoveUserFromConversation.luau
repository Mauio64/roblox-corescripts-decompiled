local CHAT_PLATFORM_BASE_URL = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/CHAT_PLATFORM_BASE_URL")

return require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/rodux/RoduxNetworking").POST("RemoveUserFromConversation", function(callback, p2, p3)
	local v5 = tonumber(p3)
	assert(v5, "Invalid removingUserId provided. Could not be converted to a number.")

	return callback(CHAT_PLATFORM_BASE_URL):path("v1"):path("remove-users"):body({
		conversation_id = p2,
		user_ids = { v5 }
	})
end)
