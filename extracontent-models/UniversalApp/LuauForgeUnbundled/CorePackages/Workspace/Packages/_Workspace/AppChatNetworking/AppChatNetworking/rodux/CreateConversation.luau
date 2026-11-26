local LuauPolyfill = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/LuauPolyfill")
local CHAT_PLATFORM_BASE_URL = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/CHAT_PLATFORM_BASE_URL")

local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/rodux/RoduxNetworking")

require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/responses/SharedTypes")

return RoduxNetworking.POST("CreateConversation", function(callback, p2, p3, p4)
	local mapped = LuauPolyfill.Array.map(p3, function(p5)
		return (tonumber(p5))
	end)

	return callback(CHAT_PLATFORM_BASE_URL):path("v1"):path("create-conversations"):body({
		conversations = {
			{ type = p2, name = p4, participant_user_ids = mapped }
		}
	}):setStatusIds(p3)
end)
