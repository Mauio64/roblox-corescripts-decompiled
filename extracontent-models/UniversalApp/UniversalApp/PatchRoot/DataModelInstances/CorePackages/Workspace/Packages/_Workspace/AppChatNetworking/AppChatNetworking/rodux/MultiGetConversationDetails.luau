local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local AppChatNetworkingParent = AppChatNetworking.Parent
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)
local RoduxNetworking = require(script.Parent.RoduxNetworking)
local GetFFlagEnableSocialCards = require(AppChatNetworkingParent.SharedFlags).GetFFlagEnableSocialCards

return RoduxNetworking.POST(script.Name, function(p1, t1: {[any]: any}) -- line: 9
	-- upvalues: CHAT_PLATFORM_BASE_URL (copy), GetFFlagEnableSocialCards (copy)
	return p1(CHAT_PLATFORM_BASE_URL):path("v1"):path("get-conversations"):body({
		include_participants = true,
		include_user_data = true,
		include_messages = true,
		check_for_group_up = true,
		ids = t1,
		include_cards = not not GetFFlagEnableSocialCards()
	}):setStatusIds(t1)
end)
