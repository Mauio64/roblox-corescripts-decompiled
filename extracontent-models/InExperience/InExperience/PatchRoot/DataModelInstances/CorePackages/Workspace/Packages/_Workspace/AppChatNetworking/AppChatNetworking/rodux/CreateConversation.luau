local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local parent = AppChatNetworking.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)

local RoduxNetworking = require(script.Parent.RoduxNetworking)

require(AppChatNetworking.responses.SharedTypes)

return RoduxNetworking.POST(script.Name, function(callback, p, p2, name: string?)
	local mapped = LuauPolyfill.Array.map(p2, function(p3)
		return (tonumber(p3))
	end)

	return callback(CHAT_PLATFORM_BASE_URL):path("v1"):path("create-conversations"):body({
		conversations = {
			{ type = p, name = name, participant_user_ids = mapped }
		}
	}):setStatusIds(p2)
end)
