local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)

return require(script.Parent.RoduxNetworking).POST(script.Name, function(p1, s1: string, s2: string) -- line: 6
	-- upvalues: CHAT_PLATFORM_BASE_URL (copy)
	local num = tonumber(s2)

	assert(num, "Invalid removingUserId provided. Could not be converted to a number.")

	return p1(CHAT_PLATFORM_BASE_URL):path("v1"):path("remove-users"):body({
		conversation_id = s1,
		user_ids = { num }
	})
end)
