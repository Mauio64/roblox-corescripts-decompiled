local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)

return require(script.Parent.RoduxNetworking).POST(script.Name, function(p1, p2) -- line: 6
	-- upvalues: CHAT_PLATFORM_BASE_URL (copy)
	return p1(CHAT_PLATFORM_BASE_URL):path("v2"):path("get-modal-sequence"):body({
		modal_sequence = "chat_landing_modal",
		is_in_experience = p2
	}):setStatusIds({ "chat_landing_modal" })
end)
