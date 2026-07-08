local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)
local RoduxNetworking = require(script.Parent.RoduxNetworking)
local AppChatNetworkingParent = AppChatNetworking.Parent
local GetFFlagIsSquadEnabled = require(AppChatNetworkingParent.SharedFlags).GetFFlagIsSquadEnabled
local GetFFlagEnableSocialCards = require(AppChatNetworkingParent.SharedFlags).GetFFlagEnableSocialCards

return RoduxNetworking.POST(script.Name, function(p1, s1: string) -- line: 9
	-- upvalues: CHAT_PLATFORM_BASE_URL (copy), GetFFlagEnableSocialCards (copy), GetFFlagIsSquadEnabled (copy)
	return p1(CHAT_PLATFORM_BASE_URL):path("v1"):path("get-conversations"):body({
		include_participants = true,
		include_user_data = true,
		include_messages = true,
		ids = { s1 },
		include_cards = not not GetFFlagEnableSocialCards(),
		check_for_group_up = not not GetFFlagIsSquadEnabled()
	}):setStatusIds({ s1 })
end)
