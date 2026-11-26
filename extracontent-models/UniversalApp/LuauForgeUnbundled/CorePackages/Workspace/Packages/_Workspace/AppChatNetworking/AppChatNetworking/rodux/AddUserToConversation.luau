local LuauPolyfill = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/LuauPolyfill")

local CHAT_PLATFORM_BASE_URL = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/CHAT_PLATFORM_BASE_URL")

return require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/rodux/RoduxNetworking").POST("AddUserToConversation", function(callback, p2, p3)
	local mapped = LuauPolyfill.Array.map(p3, function(p4)
		return (tonumber(p4))
	end)

	return callback(CHAT_PLATFORM_BASE_URL):path("v1"):path("add-users"):body({
		conversation_id = p2,
		user_ids = mapped
	})
end)
