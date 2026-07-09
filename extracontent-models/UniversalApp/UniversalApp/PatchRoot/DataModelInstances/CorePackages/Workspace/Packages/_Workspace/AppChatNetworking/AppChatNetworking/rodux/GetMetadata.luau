local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)

return require(script.Parent.RoduxNetworking).GET(script.Name, function(p1) -- line: 6
	-- upvalues: CHAT_PLATFORM_BASE_URL (copy)
	return p1(CHAT_PLATFORM_BASE_URL):path("v1"):path("metadata")
end)
