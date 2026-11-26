local HttpService = game:GetService("HttpService")

local CHAT_PLATFORM_BASE_URL = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/CHAT_PLATFORM_BASE_URL")
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/HttpRequest").default
local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/SharedFlags").GetFFlagIsSquadEnabled
local getFFlagEnableSocialCards = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/SharedFlags").GetFFlagEnableSocialCards

return function(p2, p3, cursor, p4, placement)
	if cursor == nil or cursor == "" then
		cursor = nil
	end

	local jsonEncode = HttpService:JSONEncode({
		query = p3,
		limit = p4,
		cursor = cursor,
		placement = placement,
		include_user_data = true,
		include_participants = true,
		include_messages = true,
		include_cards = getFFlagEnableSocialCards() and true or false,
		check_for_group_up = getFFlagIsSquadEnabled() and true or false
	})

	return (p2 or default)(`{module}/v1/search-conversations`, "POST", {
		postBody = jsonEncode
	})
end
