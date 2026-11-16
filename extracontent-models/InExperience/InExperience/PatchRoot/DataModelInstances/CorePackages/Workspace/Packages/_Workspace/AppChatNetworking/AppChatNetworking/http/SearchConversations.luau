local HttpService = game:GetService("HttpService")

local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local parent = AppChatNetworking.Parent

local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)
local HttpRequest = require(AppChatNetworking.url.HttpRequest)
local default = HttpRequest.default
local SharedFlags = require(parent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local SharedFlags2 = require(parent.SharedFlags)
local GetFFlagEnableSocialCards = SharedFlags2.GetFFlagEnableSocialCards

return function(p, query: string, cursor: string?, limit: number?)
	if cursor == nil or cursor == "" then
		cursor = nil
	end

	local jsonEncode = HttpService:JSONEncode({
		query = query,
		limit = limit,
		cursor = cursor,
		include_user_data = true,
		include_participants = true,
		include_messages = true,
		include_cards = GetFFlagEnableSocialCards() and true or false,
		check_for_group_up = GetFFlagIsSquadEnabled() and true or false
	})

	return (p or default)(`{CHAT_PLATFORM_BASE_URL}/v1/search-conversations`, "POST", {
		postBody = jsonEncode
	})
end
