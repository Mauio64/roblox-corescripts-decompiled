local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local AppChatNetworkingParent = AppChatNetworking.Parent
local LuauPolyfill = require(AppChatNetworkingParent.LuauPolyfill)
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)

return require(script.Parent.RoduxNetworking).POST(script.Name, function(p1, s1: string, t1: {[any]: any}) -- line: 10
	-- upvalues: LuauPolyfill (copy), CHAT_PLATFORM_BASE_URL (copy)
	local v8 = LuauPolyfill.Array.map(t1, function(p2) -- line: 11
		return (tonumber(p2))
	end)

	return p1(CHAT_PLATFORM_BASE_URL):path("v1"):path("expand-to-group-conversation"):body({
		source_conversation_id = s1,
		participant_user_ids = v8
	}):setStatusIds({ s1 })
end)
