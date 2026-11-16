local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)

local RoduxNetworking = require(script.Parent.RoduxNetworking)

return RoduxNetworking.POST(script.Name, function(callback, id: string, name: string)
	return callback(CHAT_PLATFORM_BASE_URL):path("v1"):path("update-conversations"):body({
		conversations = {
			{ id = id, name = name }
		}
	}):setStatusIds(id)
end)
