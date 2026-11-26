local CHAT_PLATFORM_BASE_URL = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/CHAT_PLATFORM_BASE_URL")

return require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/rodux/RoduxNetworking").POST("GetPendingStateModal", function(callback, p2, p3)
	return callback(CHAT_PLATFORM_BASE_URL):path("v2"):path("get-modal-sequence"):body({
		is_in_experience = p3,
		conversation_id = p2,
		modal_sequence = "pending_state_modal"
	})
end)
