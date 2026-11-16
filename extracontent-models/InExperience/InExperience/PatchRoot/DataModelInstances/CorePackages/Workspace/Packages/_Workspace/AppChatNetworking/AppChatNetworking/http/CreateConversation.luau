local HttpService = game:GetService("HttpService")
local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local parent = AppChatNetworking.Parent
local LuauPolyfill = require(parent.LuauPolyfill)

local HttpRequest = require(AppChatNetworking.url.HttpRequest)
local default = HttpRequest.default
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)

return function(p, p2: string, p3, name: string?)
	local jsonEncode = HttpService:JSONEncode({
		conversations = {
			{
				type = p2,
				name = name,
				participant_user_ids = LuauPolyfill.Array.map(p3, function(p4)
					return (tonumber(p4))
				end)
			}
		}
	})

	return (p or default)(`{CHAT_PLATFORM_BASE_URL}/v1/create-conversations`, "POST", {
		postBody = jsonEncode
	})
end
