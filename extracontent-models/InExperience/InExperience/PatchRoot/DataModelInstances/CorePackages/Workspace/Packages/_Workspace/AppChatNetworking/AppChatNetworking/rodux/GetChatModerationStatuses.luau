local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)

return (require(script.Parent.RoduxNetworking).POST(script.Name, function(p1, t1: {[any]: any}?) -- line: 8
	-- upvalues: CHAT_PLATFORM_BASE_URL (copy)
	local v5 = p1(CHAT_PLATFORM_BASE_URL):path("v1"):path("get-chat-moderation-statuses"):body({
		ids = t1 or {}
	})

	if t1 and #t1 > 0 then
		v5 = v5:setStatusIds(t1)
	end

	return v5
end))
