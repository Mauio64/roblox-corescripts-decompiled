local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)

return require(script.Parent.RoduxNetworking).POST(script.Name, function(p1, s1: string, s2: string) -- line: 6
	-- upvalues: CHAT_PLATFORM_BASE_URL (copy)
	return p1(CHAT_PLATFORM_BASE_URL):path("v1"):path("translate-user-message"):body({
		conversation_id = s1,
		message_id = s2
	})
end)
