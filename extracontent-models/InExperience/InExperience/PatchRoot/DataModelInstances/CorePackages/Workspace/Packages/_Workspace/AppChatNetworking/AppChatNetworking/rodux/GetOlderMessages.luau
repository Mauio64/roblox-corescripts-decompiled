local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local AppChatNetworkingParent = AppChatNetworking.Parent
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)
local RoduxNetworking = require(script.Parent.RoduxNetworking)
local GetFFlagEnableSocialCards = require(AppChatNetworkingParent.SharedFlags).GetFFlagEnableSocialCards

return RoduxNetworking.GET(script.Name, function(p1, p2, p3) -- line: 16
	-- upvalues: CHAT_PLATFORM_BASE_URL (copy), GetFFlagEnableSocialCards (copy)
	return p1(CHAT_PLATFORM_BASE_URL):path("v1"):path("get-conversation-messages"):queryArgs({
		conversation_id = p2,
		cursor = p3,
		include_cards = not not GetFFlagEnableSocialCards()
	}):setStatusIds({ p2 })
end)
