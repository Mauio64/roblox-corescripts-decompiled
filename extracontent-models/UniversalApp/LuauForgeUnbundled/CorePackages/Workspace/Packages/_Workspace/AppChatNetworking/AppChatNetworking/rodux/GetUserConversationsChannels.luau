local CHAT_PLATFORM_BASE_URL = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/CHAT_PLATFORM_BASE_URL")

local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/rodux/RoduxNetworking")

local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/SharedFlags").GetFFlagIsSquadEnabled
local getFFlagEnableSocialCards = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/SharedFlags").GetFFlagEnableSocialCards

return RoduxNetworking.GET("GetUserConversationsChannels", function(callback, p2)
	return callback(CHAT_PLATFORM_BASE_URL):path("v1"):path("get-user-conversations"):queryArgs({
		cursor = p2,
		include_cards = getFFlagEnableSocialCards() and true or false,
		include_user_data = true,
		include_messages = true,
		check_for_group_up = getFFlagIsSquadEnabled() and true or false
	})
end)
