local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local parent = AppChatNetworking.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)

local RoduxNetworking = require(script.Parent.RoduxNetworking)

return RoduxNetworking.POST(script.Name, function(callback, source_conversation_id: string, p)
	local mapped = LuauPolyfill.Array.map(p, function(p2)
		return (tonumber(p2))
	end)

	return callback(CHAT_PLATFORM_BASE_URL):path("v1"):path("expand-to-group-conversation"):body({
		source_conversation_id = source_conversation_id,
		participant_user_ids = mapped
	}):setStatusIds({ source_conversation_id })
end)
