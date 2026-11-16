local CHAT_PLATFORM_BASE_URL = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/CHAT_PLATFORM_BASE_URL")

return (require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/rodux/RoduxNetworking").POST("GetChatModerationStatuses", function(callback, options)
	local body = callback(CHAT_PLATFORM_BASE_URL):path("v1"):path("get-chat-moderation-statuses"):body({
		ids = options or {}
	})

	if options and #options > 0 then
		body = body:setStatusIds(options)
	end

	return body
end))
