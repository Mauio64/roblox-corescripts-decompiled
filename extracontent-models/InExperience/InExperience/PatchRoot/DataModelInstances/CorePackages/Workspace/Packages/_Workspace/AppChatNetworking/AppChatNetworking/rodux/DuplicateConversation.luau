local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)
local RoduxNetworking = require(script.Parent.RoduxNetworking)

require(AppChatNetworking.responses.SharedTypes)

return RoduxNetworking.POST(script.Name, function(p1, s1: string, p2) -- line: 10
	-- upvalues: CHAT_PLATFORM_BASE_URL (copy)
	return p1(CHAT_PLATFORM_BASE_URL):path("v1"):path("create-conversations"):body({
		conversations = {{
			type = "group",
			conversation_to_duplicate = s1,
			moderation_type = p2,
			participant_user_ids = {}
		}}
	}):setStatusIds({ s1 })
end)
