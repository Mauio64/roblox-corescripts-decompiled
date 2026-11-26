local HttpService = game:GetService("HttpService")

local LuauPolyfill = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/LuauPolyfill")

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/HttpRequest").default
local CHAT_PLATFORM_BASE_URL = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/CHAT_PLATFORM_BASE_URL")

return function(p2, p3, p4, p5)
	local jsonEncode = HttpService:JSONEncode({
		conversations = {
			{
				type = p3,
				name = p5,
				participant_user_ids = LuauPolyfill.Array.map(p4, function(p6)
					return (tonumber(p6))
				end)
			}
		}
	})

	return (p2 or default)(`{module2}/v1/create-conversations`, "POST", {
		postBody = jsonEncode
	})
end
