local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)

local RoduxNetworking = require(script.Parent.RoduxNetworking)

return RoduxNetworking.POST(script.Name, function(callback, is_in_experience)
	return callback(CHAT_PLATFORM_BASE_URL):path("v2"):path("get-modal-sequence"):body({
		is_in_experience = is_in_experience,
		modal_sequence = "chat_landing_modal"
	}):setStatusIds({ "chat_landing_modal" })
end)
