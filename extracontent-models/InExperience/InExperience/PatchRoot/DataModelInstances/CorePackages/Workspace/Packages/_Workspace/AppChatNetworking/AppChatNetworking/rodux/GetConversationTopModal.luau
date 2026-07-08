local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)
local Packages = script:FindFirstAncestor("Packages")
local RoduxNetworking = require(script.Parent.RoduxNetworking)
local v5 = require(Packages.Loggers).Logger:new(script.Name)

return RoduxNetworking.POST(script.Name, function(p1, p2, p3, p4) -- line: 9
	-- upvalues: v5 (copy), CHAT_PLATFORM_BASE_URL (copy)
	if p2 and p4 then
		v5:warning("Both conversation ID and friend ID provided to GetConversationTopModal.")
	end

	local t1 = {
		modal_sequence = "conversation_top_modal",
		is_in_experience = p3,
		conversation_id = p2,
		friend_id = p4
	}

	return p1(CHAT_PLATFORM_BASE_URL):path("v2"):path("get-modal-sequence"):body(t1)
end)
