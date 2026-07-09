local HttpService = game:GetService("HttpService")
local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local AppChatNetworkingParent = AppChatNetworking.Parent
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)
local default = require(AppChatNetworking.url.HttpRequest).default
local Object = require(AppChatNetworkingParent.LuauPolyfill).Object
local t1 = {
	include_participants = true,
	include_user_data = true,
	include_messages = true
}

return function(p1, s1: string, t2: {[any]: any}?) -- line: 24
	-- upvalues: default (copy), Object (copy), t1 (copy), HttpService (copy), CHAT_PLATFORM_BASE_URL (copy)
	local v11 = p1 or default
	local v12 = Object.assign({}, t1, t2 or {})
	local json = HttpService:JSONEncode({
		ids = { s1 },
		include_participants = v12.include_participants,
		include_user_data = v12.include_user_data,
		include_messages = v12.include_messages
	})

	return v11(`{ CHAT_PLATFORM_BASE_URL }/v1/get-conversations`, "POST", {
		postBody = json
	})
end
