local CHAT_PLATFORM_BASE_URL = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/CHAT_PLATFORM_BASE_URL")

local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/rodux/RoduxNetworking")

local getFFlagEnableSocialCards = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/SharedFlags").GetFFlagEnableSocialCards

return RoduxNetworking.POST("MultiGetConversationDetails", function(callback, p2)
	return callback(CHAT_PLATFORM_BASE_URL):path("v1"):path("get-conversations"):body({
		ids = p2,
		include_cards = getFFlagEnableSocialCards() and true or false,
		include_participants = true,
		include_user_data = true,
		include_messages = true,
		check_for_group_up = true
	}):setStatusIds(p2)
end)
