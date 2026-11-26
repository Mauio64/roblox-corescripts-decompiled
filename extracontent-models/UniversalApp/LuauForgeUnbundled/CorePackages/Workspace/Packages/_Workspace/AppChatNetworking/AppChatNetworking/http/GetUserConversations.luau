local HttpService = game:GetService("HttpService")

local CHAT_PLATFORM_BASE_URL = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/CHAT_PLATFORM_BASE_URL")
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/HttpRequest").default
local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/SharedFlags").GetFFlagIsSquadEnabled
local getFFlagEnableSocialCards = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/SharedFlags").GetFFlagEnableSocialCards

local function appendQueryArgs(p2, items)
	local v5 = {}

	for k, item in items do
		if item ~= nil then
			table.insert(v5, `{HttpService:UrlEncode(k)}={HttpService:UrlEncode((tostring(item)))}`)
		end
	end

	if #v5 == 0 then
		return p2
	end

	return `{p2}?{table.concat(v5, "&")}`
end

return function(p2, cursor)
	if cursor == nil or cursor == "" then
		cursor = nil
	end

	local v6 = {
		cursor = cursor,
		include_cards = getFFlagEnableSocialCards() and true or false,
		include_user_data = true,
		check_for_group_up = getFFlagIsSquadEnabled() and true or false
	}

	return (p2 or default)(appendQueryArgs(`{module}/v1/get-user-conversations`, v6), "GET")
end
