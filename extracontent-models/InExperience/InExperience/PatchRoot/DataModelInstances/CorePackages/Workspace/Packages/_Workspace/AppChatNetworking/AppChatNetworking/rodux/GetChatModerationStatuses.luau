local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")

local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)

local RoduxNetworking = require(script.Parent.RoduxNetworking)

return (RoduxNetworking.POST(script.Name, function(callback, options)
	local body = callback(CHAT_PLATFORM_BASE_URL):path("v1"):path("get-chat-moderation-statuses"):body({
		ids = options or {}
	})

	if options and #options > 0 then
		body = body:setStatusIds(options)
	end

	return body
end))
