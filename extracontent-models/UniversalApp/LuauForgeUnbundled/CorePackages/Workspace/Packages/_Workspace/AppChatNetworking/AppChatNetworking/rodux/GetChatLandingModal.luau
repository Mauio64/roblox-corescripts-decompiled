local CHAT_PLATFORM_BASE_URL = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/CHAT_PLATFORM_BASE_URL")

return require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/rodux/RoduxNetworking").POST("GetChatLandingModal", function(callback, p2)
	return callback(CHAT_PLATFORM_BASE_URL):path("v2"):path("get-modal-sequence"):body({
		is_in_experience = p2,
		modal_sequence = "chat_landing_modal"
	}):setStatusIds({ "chat_landing_modal" })
end)
