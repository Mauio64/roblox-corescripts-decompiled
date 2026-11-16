local HttpService = game:GetService("HttpService")
local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local parent = AppChatNetworking.Parent

local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)
local HttpRequest = require(AppChatNetworking.url.HttpRequest)
local default = HttpRequest.default
local LuauPolyfill = require(parent.LuauPolyfill)
local Object = LuauPolyfill.Object
local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnableSocialCards = SharedFlags.GetFFlagEnableSocialCards

local v = { include_participants = true, include_user_data = true, include_messages = true }

return function(p, p2: string, options)
	local v2 = Object.assign({}, v, options or {})

	local jsonEncode = HttpService:JSONEncode({
		ids = { p2 },
		include_participants = v2.include_participants,
		include_user_data = v2.include_user_data,
		include_messages = v2.include_messages,
		include_cards = GetFFlagEnableSocialCards() and true or false
	})

	return (p or default)(`{CHAT_PLATFORM_BASE_URL}/v1/get-conversations`, "POST", {
		postBody = jsonEncode
	})
end
