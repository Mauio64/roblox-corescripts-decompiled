local HttpService = game:GetService("HttpService")

local CHAT_PLATFORM_BASE_URL = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/CHAT_PLATFORM_BASE_URL")
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/HttpRequest").default
local object = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/LuauPolyfill").Object
local getFFlagEnableSocialCards = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/SharedFlags").GetFFlagEnableSocialCards

local v5 = {
	include_participants = true,
	include_user_data = true,
	include_messages = true
}

return function(p2, p3, options)
	local v7 = object.assign({}, v5, options or {})

	local jsonEncode = HttpService:JSONEncode({
		ids = { p3 },
		include_participants = v7.include_participants,
		include_user_data = v7.include_user_data,
		include_messages = v7.include_messages,
		include_cards = getFFlagEnableSocialCards() and true or false
	})

	return (p2 or default)(`{module}/v1/get-conversations`, "POST", {
		postBody = jsonEncode
	})
end
