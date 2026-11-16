local CHAT_PLATFORM_BASE_URL = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/CHAT_PLATFORM_BASE_URL")

local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/rodux/RoduxNetworking")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/Constants")

local getFFlagEnableSocialCards = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/SharedFlags").GetFFlagEnableSocialCards

return RoduxNetworking.GET("GetNewerMessages", function(callback, p2, p3)
	return callback(CHAT_PLATFORM_BASE_URL):path("v1"):path("get-conversation-messages"):queryArgs({
		conversation_id = p2,
		cursor = p3,
		Constants.PageSize.GET_NEW_MESSAGES,
		include_cards = getFFlagEnableSocialCards() and true or false
	}):setStatusIds({ p2 })
end)
