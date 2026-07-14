local HttpService = game:GetService("HttpService")
local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local AppChatNetworkingParent = AppChatNetworking.Parent
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)
local default = require(AppChatNetworking.url.HttpRequest).default
local Object = require(AppChatNetworkingParent.LuauPolyfill).Object
local GetFFlagEnableSocialCards = require(AppChatNetworkingParent.SharedFlags).GetFFlagEnableSocialCards
local t1 = {
	include_participants = true,
	include_user_data = true,
	include_messages = true
}

return function(p1, s1: string, t2: {[any]: any}?) -- line: 25
	-- upvalues: default (copy), Object (copy), t1 (copy), HttpService (copy), GetFFlagEnableSocialCards (copy), CHAT_PLATFORM_BASE_URL (copy)
	local v12 = p1 or default
	local v13 = Object.assign({}, t1, t2 or {})
	local json = HttpService:JSONEncode({
		ids = { s1 },
		include_participants = v13.include_participants,
		include_user_data = v13.include_user_data,
		include_messages = v13.include_messages,
		include_cards = not not GetFFlagEnableSocialCards()
	})

	return v12(`{ CHAT_PLATFORM_BASE_URL }/v1/get-conversations`, "POST", {
		postBody = json
	})
end
