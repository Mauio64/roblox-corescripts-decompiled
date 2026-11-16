local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)

local RoduxNetworking = require(script.Parent.RoduxNetworking)
local parent = AppChatNetworking.Parent
local SharedFlags = require(parent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local SharedFlags2 = require(parent.SharedFlags)
local GetFFlagEnableSocialCards = SharedFlags2.GetFFlagEnableSocialCards

return RoduxNetworking.GET(script.Name, function(callback, cursor: string?)
	return callback(CHAT_PLATFORM_BASE_URL):path("v1"):path("get-user-conversations"):queryArgs({
		cursor = cursor,
		include_cards = GetFFlagEnableSocialCards() and true or false,
		include_user_data = true,
		include_messages = true,
		check_for_group_up = GetFFlagIsSquadEnabled() and true or false
	})
end)
