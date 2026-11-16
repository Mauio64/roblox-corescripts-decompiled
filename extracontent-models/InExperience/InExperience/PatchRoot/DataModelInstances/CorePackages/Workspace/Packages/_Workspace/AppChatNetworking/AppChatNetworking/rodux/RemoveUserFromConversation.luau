local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)

local RoduxNetworking = require(script.Parent.RoduxNetworking)

return RoduxNetworking.POST(script.Name, function(callback, conversation_id: string, p: string)
	local v = tonumber(p)
	assert(v, "Invalid removingUserId provided. Could not be converted to a number.")

	return callback(CHAT_PLATFORM_BASE_URL):path("v1"):path("remove-users"):body({
		conversation_id = conversation_id,
		user_ids = { v }
	})
end)
