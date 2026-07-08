local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local AppChatNetworkingParent = AppChatNetworking.Parent
local LuauPolyfill = require(AppChatNetworkingParent.LuauPolyfill)
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)
local RoduxNetworking = require(script.Parent.RoduxNetworking)

require(AppChatNetworking.responses.SharedTypes)

return RoduxNetworking.POST(script.Name, function(p1, p2, t1: {[any]: any}, s1: string?) -- line: 15
	-- upvalues: LuauPolyfill (copy), CHAT_PLATFORM_BASE_URL (copy)
	local v10 = LuauPolyfill.Array.map(t1, function(p3) -- line: 21
		return (tonumber(p3))
	end)

	return p1(CHAT_PLATFORM_BASE_URL):path("v1"):path("create-conversations"):body({
		conversations = {{
			type = p2,
			name = s1,
			participant_user_ids = v10
		}}
	}):setStatusIds(t1)
end)
