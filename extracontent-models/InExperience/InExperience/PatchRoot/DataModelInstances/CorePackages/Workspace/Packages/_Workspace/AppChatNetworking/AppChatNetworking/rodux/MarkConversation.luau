local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)

local RoduxNetworking = require(script.Parent.RoduxNetworking)

return RoduxNetworking.POST(script.Name, function(callback, p: string)
	return callback(CHAT_PLATFORM_BASE_URL):path("v1"):path("mark-conversations"):body({
		conversation_ids = { p }
	}):setStatusIds({ p })
end)
