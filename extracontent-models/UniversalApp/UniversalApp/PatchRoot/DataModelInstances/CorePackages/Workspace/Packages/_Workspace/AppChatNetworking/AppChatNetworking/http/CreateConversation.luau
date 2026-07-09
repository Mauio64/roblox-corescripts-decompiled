local HttpService = game:GetService("HttpService")
local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local AppChatNetworkingParent = AppChatNetworking.Parent
local LuauPolyfill = require(AppChatNetworkingParent.LuauPolyfill)
local default = require(AppChatNetworking.url.HttpRequest).default
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)

return function(p1, s1: string, t1: {[any]: any}, s2: string?) -- line: 11
	-- upvalues: default (copy), LuauPolyfill (copy), HttpService (copy), CHAT_PLATFORM_BASE_URL (copy)
	local v11 = p1 or default
	local v12 = LuauPolyfill.Array.map(t1, function(p2) -- line: 18
		return (tonumber(p2))
	end)
	local json = HttpService:JSONEncode({
		conversations = {{
			type = s1,
			name = s2,
			participant_user_ids = v12
		}}
	})

	return v11(`{ CHAT_PLATFORM_BASE_URL }/v1/create-conversations`, "POST", {
		postBody = json
	})
end
