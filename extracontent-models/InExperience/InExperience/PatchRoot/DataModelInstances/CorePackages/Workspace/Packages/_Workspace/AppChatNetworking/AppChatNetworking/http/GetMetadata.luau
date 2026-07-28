local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)
local default = require(AppChatNetworking.url.HttpRequest).default

return function(p1) -- line: 6
	-- upvalues: default (copy), CHAT_PLATFORM_BASE_URL (copy)
	return (p1 or default)(`{ CHAT_PLATFORM_BASE_URL }/v1/metadata`, "GET")
end
